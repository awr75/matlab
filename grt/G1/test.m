clear all;
close all;
clc;
% Gegebene Spezifikationen
fs = 1000; % Abtastfrequenz in Hz
fc = 400; % Grenzfrequenz in Hz
N = 4; % Filterordnung
% 1. Prewarping der Grenzfrequenz
 
Ts = 1/fs; % Abtastperiode
 
% TODO:
%fc_analog = ...
fc_analog = tan(pi*fc*Ts)/(pi*Ts)
% 2. Entwurf des analogen Butterworth-Filters und Bilinear Trafo um
% digitales Filter zu erhalten
[z, p, k] = butter(N, 2*pi*fc_analog, 's');
[zd, pd, kd] = bilinear(z, p, k, fs);
[bz, az] = zp2tf(zd, pd, kd);
% 4. Frequenzantwort des digitalen Filters
[H, f] = freqz(bz, az, 1024, fs);
% 5. Plot der Frequenzantwort
figure;
subplot(2,1,1);
plot(f, 20*log10(abs(H))); hold on; % Magnitude in dB
yline(-3, 'r:', "LineWidth", 1);
title('Frequenzantwort des digitalen Butterworth-Filters');
xlabel('Frequenz (Hz)');
ylabel('Magnitude (dB)');
grid on;
xlim([0 fs/2]);
subplot(2,1,2);
plot(f, unwrap(angle(H))*180/pi); % Phase in Grad
xlabel('Frequenz (Hz)');
ylabel('Phase (Grad)');
grid on;
xlim([0 fs/2]);
[~, idx] = min(abs(20*log10(abs(H)) + 3));
fprintf('Actual -3 dB frequency: %.2f Hz (target: %.2f Hz)\n', f(idx), fc);