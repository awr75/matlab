function sig_sinussignal_spektrum
% Praktische Berechnung des Spektrums eines Sinussignals
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
t_a = 1 / f_a;
f = 13 * f_a / N;
t = (0 : N - 1) * t_a;
x = sin(2 * pi * f * t);

% Fenster-Funktion
w = blackman_window(N);

% Fensterung des Signals
x_w = x .* w;

% Berechnung der FFT
X_w = fftshift(fft(x_w));

% Normierungsfaktor
c_w = sum(w);

% Berechnung des Spektrums
S_x = abs(X_w).^2 / c_w^2;

% Frequenzachse
f = (-N/2 : N/2 - 1) * f_a / N;

figure(1);
plot(t,x,'b-','Linewidth',1);
hold on;
plot(t,x,'bs','Linewidth',3,'Markersize',2);
hold off;
grid on;
axis([min(t) max(t) -1.1 1.1]);
xlabel('t [s]');
title('Sinus-Signal');

figure(2);
plot(t,x_w,'b-','Linewidth',1);
hold on;
plot(t,x_w,'bs','Linewidth',3,'Markersize',2);
hold off;
grid on;
axis([min(t) max(t) -1.1 1.1]);
xlabel('t [s]');
title('Gefenstertes Sinus-Signal');

figure(3);
plot(f,S_x,'b-','Linewidth',1);
hold on;
plot(f,S_x,'bs','Linewidth',3,'Markersize',2);
hold off;
grid on;
axis([-f_a/2 f_a/2 0 0.3]);
xlabel('f [Hz]');
title('Spektrum');
