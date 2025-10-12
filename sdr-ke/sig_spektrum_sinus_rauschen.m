function sig_spektrum_sinus_rauschen
% Anzeige des Spektrums eines Sinus-Signals mit Rauschen
% Anzeige eines Spektrums eines Mehrfrequenzssignals
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Sinus-Signal erzeugen
f_a = 1000;
t_a = 1 / f_a;
f = 150;
x = sin(2 * pi * f * t_a * (1:3e4));

% Rauschen addieren
x = x + 2 * randn(1,length(x));

% Spektren fuer verschiedene FFT-Laengen berechnen
n_fft = [256 512 1024];
l_fft = length(n_fft);
s_x_m = zeros(l_fft,max(n_fft));
f_m   = s_x_m;
for i = 1 : l_fft
    n_fft_i = n_fft(i);
    w = blackman_window(n_fft_i);
    n = floor(2 * length(x) / n_fft_i) - 1;
    s_x = zeros(1,n_fft_i);
    idx = 0;
    for k = 1 : n
        s_x = s_x + abs(fft(w .* x(idx + 1 : idx + n_fft_i))).^2;
        idx = idx + n_fft_i / 2;
    end
    s_x_m(i,1:n_fft_i) = 10 * log10(fftshift(s_x) / (n * sum(w)^2) + 1e-12);
    f_m(i,1:n_fft_i) = (-n_fft_i/2 : n_fft_i/2 - 1) * f_a / n_fft_i;
end

figure(1);
plot(f_m(1,1:n_fft(1)),s_x_m(1,1:n_fft(1)),'b-','Linewidth',1);
hold on;
plot(f_m(2,1:n_fft(2)),s_x_m(2,1:n_fft(2)),'r-','Linewidth',1);
plot(f_m(3,1:n_fft(3)),s_x_m(3,1:n_fft(3)),'-','Color',[0 0.5 0],'Linewidth',1);
hold off;
grid on;
axis([-f_a/2 f_a/2 -25 -5]);
xlabel('f [Hz]');
title('Spektrum eines Sinus-Signals mit Rauschen');
legend('N_F_F_T = 256','N_F_F_T = 512','N_F_F_T = 1024','Location','SouthEast');
