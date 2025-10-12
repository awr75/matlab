function sig_fft_filterbank
% Darstellung der Filterkurven einer FFT-Filterbank
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Laenge der FFT
N = 256;

% diskretes Sinus-Signal
f_a = 1000;

% Fenster-Funktion
w = blackman_window(N);

% Ueberabtastung fuer Filterkurve
over = 64;

% Berechnung des Betragsquadrats des Basisfilters
w_over = [w zeros(1,N * (over - 1))];
W_over = abs(fftshift(fft(w_over)/sum(w))).^2;
f_over = (-N * over / 2 : N * over / 2 - 1) * f_a / (N * over);

W_over_dB = 10 * log10(W_over + 1e-12);

figure(1);
plot(0,0)
hold on;
for i=8:18
    if i == 13
        lw = 2;
    else
        lw = 1;
    end
    plot(f_over,circshift(W_over,[0 i * over]),'b-','Linewidth',lw);
    plot([1 1]*i*f_a/N,[0 1],'b--');
end
hold off;
grid on;
axis([f_a/N * [10 16] 0 1.1]);
xlabel('f [Hz]');
ylabel('|W|^2 [linear]');
title('FFT-Filterbank');

figure(2);
plot(0,0)
hold on;
for i=8:18
    if i == 13
        lw = 2;
    else
        lw = 1;
    end
    plot(f_over,circshift(W_over_dB,[0 i * over]),'b-','Linewidth',lw);
    plot([1 1]*i*f_a/N,[-100 0],'b--');
end
hold off;
grid on;
axis([f_a/N * [10 16] -20 2]);
xlabel('f [Hz]');
ylabel('|W| [dB]');
title('FFT-Filterbank');
