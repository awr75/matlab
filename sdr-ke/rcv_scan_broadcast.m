function rcv_scan_broadcast
% Scan the FM broadcast frequency band
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2017
%------------------------------------------------

close all;

% run time
run_time_sec = 1000;

% setup RTL-SDR USB receiver
sample_rate       = 640e3;
bandwidth_ddc     = 0.8 * sample_rate;
bandwidth         = 480e3;
frequency_min     = 88e6;
frequency_max     = 108e6;
center_frequency  = frequency_min + bandwidth / 2;
blocks_per_sec    = 50;
number_of_buffers = 4;
mgc_index         = 1;
mexrtlsdr('open');
mgc = mexrtlsdr('mgc');
mexrtlsdr('init',sample_rate,bandwidth_ddc,center_frequency,...
          blocks_per_sec,number_of_buffers,mgc_index);

% setup PSD display
display_range = [-60 -10];
fft_len       = 16;
used_len      = fft_len * bandwidth / sample_rate;
cut_len       = (fft_len - used_len) / 2;
bw_bin        = sample_rate / fft_len;
psd_len       = (frequency_max - frequency_min) / bw_bin + 1;
frequency     = frequency_min + (0 : psd_len - 1) * bw_bin; 
spectrum      = display_range(1) * ones(1,psd_len);
figure(1);
h = plot(1e-6 * frequency,spectrum);
grid;
axis([1e-6 * [min(frequency) max(frequency)] display_range]);
xlabel('f [MHz]');
ylabel('S [dB]');
title('PSD of the FM broadcast frequency band');

run = 1;
t = clock;
while (etime(clock,t) < run_time_sec) && (run == 1)
    % get data from the receiver
    % NOTE: we discard the first data packet because it may be corrupted
    mexrtlsdr('data',1);
    [data,id,freq] = mexrtlsdr('data',1);
    mexrtlsdr('stop');
    % next frequency
    center_frequency = center_frequency + bandwidth;
    if center_frequency > frequency_max + bandwidth / 2;
        % next run
        center_frequency = frequency_min + bandwidth / 2;
        % check MGC
        spectrum_max = max(spectrum);
        if spectrum_max < -25
            ref = spectrum_max - mgc(mgc_index);
            % we need more gain
            for i = mgc_index : numel(mgc)
                if ref + mgc(i) > -25
                    break;
                end
            end
            if ref + mgc(i) > -15
                i = max(i - 1,1);
            end
            mgc_index = i;
            mexrtlsdr('init',sample_rate,bandwidth_ddc,center_frequency,...
                      blocks_per_sec,number_of_buffers,mgc_index);
        end
    end
    mexrtlsdr('freq',center_frequency);
    % calculate PSD of the data
    s = power_spectrum_density(data,sample_rate,fft_len);
    % find the location
    idx = round((freq - frequency_min - bandwidth / 2) * used_len / bandwidth);
    % copy the used values to the spectrum
    len = min(used_len,psd_len - idx);
    spectrum(idx+(1:len)) = s(cut_len+(1:len));
    % update the spectrum
    try
        set(h,'YData',spectrum);
        drawnow;
    catch
        run = 0;
    end
end
mexrtlsdr('stop');
mexrtlsdr('close');
