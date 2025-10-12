function sig_tiefpassfilter
% Tiefpass-Filter fuer Ueber-/Unterabtastung
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Abtastraten
f_a_low  = 200;
f_a_high = 1000;

% Impulsantwort des Filters berechnen
N_h = 40;
M = f_a_high / f_a_low;
n = 1 : N_h;
h = sin( pi * n / M ) ./ ( pi * n );
h = [ fliplr(h) 1/M h ];
n = [ -fliplr(n) 0 n ];

% diskretes Signal
t = 0.05 : 0.05 : ( N_h + 0.5 );
h_t = sin( pi * t / M ) ./ ( pi * t );
h_t = [ fliplr(h_t) 1/M h_t ];
t = [ -fliplr(t) 0 t ];

% Frequenzgang berechnen
[H,f] = freqz(h,1,1024,'whole',f_a_high);
f = mod(fftshift(f) + f_a_high / 2,f_a_high) - f_a_high / 2;
H = fftshift(H);

% Impulsantwort mit Fenster-Funktion bewerten
hw = h .* kaiser_window(length(h),6);

% Frequenzgang berechnen
Hw = freqz(hw,1,1024,'whole',f_a_high);
Hw = fftshift(Hw);

figure(1);
plot(f,20*log10(abs(H)),'b-','Linewidth',1);
hold on;
plot(f,20*log10(abs(Hw)),'r-','Linewidth',1);
hold off;
grid on;
axis([-f_a_high/2 f_a_high/2 -100 5]);
xlabel('f [Hz]');
ylabel('|H| [dB]');
title('Betragsfrequenzgang des Tiefpass-Filters');
legend('ohne Fensterung','mit Kaiser-Fenster');

figure(2);
plot(t,h_t,'b--');
hold on;
plot(n,h,'bs','Linewidth',2,'Markersize',2);
hold off;
grid on;
axis([min(t) max(t) -0.1 0.25]);
xlabel('t / T_a');
title('Koeffizienten des Tiefpass-Filters');
