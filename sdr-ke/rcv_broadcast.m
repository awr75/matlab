function rcv_broadcast
% Receive FM broadcast station with PSD display
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% run time
run_time_sec = 1000;

% setup RTL-SDR USB receiver
sample_rate       = 256e3;
bandwidth         = 200e3;
center_frequency  = 98.8e6;
blocks_per_sec    = 10;
number_of_buffers = 4;
mexrtlsdr('open');
[len,t_ref] = mexrtlsdr('init',sample_rate,bandwidth,center_frequency,...
                        blocks_per_sec,number_of_buffers,0);

% setup PSD display
fft_len = 1024;
display_range = [-80 -10];
[s,f] = power_spectrum_density([],sample_rate,fft_len);
figure(1);
h = plot(0.001*f,s);
grid;
axis([0.001*min(f)*[1 -1] display_range]);
xlabel('fo [kHz]');
ylabel('S [dB]');
title(sprintf('PSD: fc = %g MHz',1e-6 * center_frequency));

% setup polyphase filter
p_poly = 3;
q_poly = 16;
audio_sample_rate = sample_rate * p_poly / q_poly;
audio_bandwidth   = 12e3;
b_poly = lowpass_filter(audio_bandwidth/sample_rate);
[x_audio,z_poly] = mexpoly(0,p_poly,q_poly,b_poly);

% audio output
mexaudioout('init',audio_sample_rate,blocks_per_sec,number_of_buffers,t_ref);

run = 1;
update = 0;
next_id = 0;
last_sample = 1;
t = clock;
while (etime(clock,t) < run_time_sec) && (run == 1)
    % get data from the receiver
    [data,id] = mexrtlsdr('data',0);
    if isempty(data)
        if update == 1
            update = 0;
            try
                set(h,'YData',s);
                drawnow;
            catch
                run = 0;
            end
        else
            pause(0.01);
        end
    else
        % check sequence number
        if id > next_id
            for i = next_id : id-1
                fprintf(1,'Receiver: id = %4d, data lost !\n',i);
            end
        end
        next_id = id + 1;
        % calculate PSD
        s = power_spectrum_density(data,sample_rate,fft_len);
        % request update
        update = 1;
        % FM demodulation
        x_fm = angle(data .* conj([last_sample data(1:end-1)]));
        last_sample = data(end);
        % audio resampling and output
        [x_audio,z_poly] = mexpoly(x_fm,p_poly,q_poly,b_poly,z_poly);
        mexaudioout('data',x_audio);
    end
end
mexrtlsdr('stop');
mexrtlsdr('close');
mexaudioout('stop');
fprintf(1,'Blocks = %d\n',next_id);
