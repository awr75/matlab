function sig_tiefpassfilter_berechnung
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
M = f_a_high / f_a_low;
N_h = floor(16 * M);
K = 1.11;
n = 1 : N_h;
h = sin( pi * n / (K * M) ) ./ ( pi * n );
n = [ -fliplr(n) 0 n ];
h = [ fliplr(h) 1/(K * M) h ];

% kontinuierliche Funktion
ni = 0.1 : 0.1 : floor(1.25 * N_h);
hi = sin( pi * ni / (K * M)) ./ (pi * ni);
ni = [ -fliplr(ni) 0 ni ];
hi = [ fliplr(hi) 1/(K * M) hi ];

% Fenster-Funktion
w = kaiser_window(length(h),6);

% Filter-Koeffizienten
hw = h .* w;

figure(1);
plot(ni(1:10:end),hi(1:10:end),'bs','Linewidth',2,'Markersize',2);
hold on;
plot(ni,hi,'b-');
hold off;
grid on;
axis([floor(1.25 * N_h) * [-1 1] -0.05 0.2001]);
xlabel('n');
title('Ideale Impulsantwort');

figure(2);
plot(n,h,'bs','Linewidth',2,'Markersize',2);
grid on;
axis([floor(1.25 * N_h) * [-1 1] -0.05 0.2001]);
xlabel('n');
title('Abgeschnittene Impulsantwort');

figure(3);
plot(n,w,'bs','Linewidth',2,'Markersize',2);
grid on;
axis([floor(1.25 * N_h) * [-1 1] 0 1.1]);
xlabel('n');
title('Fenster-Funktion');

figure(4);
plot(n,hw,'bs','Linewidth',2,'Markersize',2);
grid on;
axis([floor(1.25 * N_h) * [-1 1] -0.05 0.2001]);
xlabel('n');
title('Filter-Koeffizienten');
