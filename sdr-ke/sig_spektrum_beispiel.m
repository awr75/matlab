function sig_spektrum_beispiel
% Beispiel fuer die Spektrumsanzeige eines Mehrfrequenzsignals
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Signal erzeugen
[x,f_a,f_tones] = sig_mehrfrequenzsignal;

% Rauschen addieren
x = x + 0.1 * randn(1,length(x));

% Anzahl Bloecke pro Sekunde
blocks_per_sec = 20;

% Laenge eines Blocks
block_len = f_a / blocks_per_sec;
if mod(block_len,1) ~= 0
    error('Blocklaenge ist nicht ganzzahlig');
end

% Anzahl Puffer
number_of_buffers = 2;

% FFT-Laenge
n_fft = 256;

% Fenster-Funktion
w_fft = blackman_window(n_fft);
w_fft = w_fft / sum(w_fft);

% Spektrumsanzeige
f = (-n_fft/2 : n_fft/2 - 1) * f_a / n_fft;
figure(1);
subplot(2,1,1);
h1 = plot(zeros(1,block_len),'b-');
axis([1 block_len -1.5 1.5]);
xlabel('Samples');
title('Signal');
subplot(2,1,2);
h2 = plot(0.001 * f,zeros(1,n_fft),'b-','Linewidth',2);
hold on;
for i=1:length(f_tones)
    plot(0.001 * f_tones(i) * [1 1],[-60 0],'r-');
    plot(-0.001 * f_tones(i) * [1 1],[-60 0],'r-');
end
hold off;
axis([-2 2 -60 0]);
xlabel('f [kHz]');
ylabel('S [dB]');
title('Spektrum');

% Audio-Ausgabe initialisieren
mexaudioout('init',f_a,blocks_per_sec,number_of_buffers);

% Ausgabe
blocks = floor(length(x) / block_len);
t      = ((0 : blocks - 1) + 0.5) * block_len / f_a;
pos    = 0;
x_i_1  = zeros(1,block_len);
s_x_1  = -120 * ones(1,n_fft);
s_x  = zeros(blocks,n_fft);
for i = 1 : blocks
    % Signalabschnitt
    x_i = x(pos+1:pos+block_len);
    % Audio-Daten ausgeben
    mexaudioout('data',0.1 * x_i,1);
    % Spektrum berechnen
    idx = 0;
    cnt = 0;
    s_x_i = zeros(1,n_fft);
    while idx + n_fft <= block_len
        s_x_i = s_x_i + abs(fftshift(fft(x_i(idx+1:idx+n_fft) .* w_fft))).^2;
        idx = idx + n_fft/2;
        cnt = cnt + 1;
    end
    s_x(i,:) = 10 * log10(s_x_i / cnt + 1e-12);
    % Spektrum anzeigen
    set(h1,'YData',x_i_1);
    set(h2,'YData',s_x_1);
    drawnow;
    x_i_1 = x_i;
    s_x_1 = s_x(i,:);
    % naechster Block
    pos = pos + block_len;
end
% Spektrum anzeigen
pause(1/blocks_per_sec);
set(h1,'YData',x_i_1);
set(h2,'YData',s_x_1);
drawnow;

% Audio-Ausgabe stoppen
mexaudioout('stop');

if nargout == 0
    save('sig_spektrum_beispiel.mat','s_x','f','t');
end
