function ddc_halbband_filter_1
% Frequenzgang eines Halbband-FIR-Filters mit k = 1
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Sperrdaempfung in dB
a = 80;
alpha = 10^(-a/20);

% Koeffizienten
h = 0.25 * [ 1+alpha 2-2*alpha 1+alpha ];

% Frequenzgang berechnen
[ H, f ] = freqz( h, 1, 10000, 1 );
f = f(2:end-1);
H = 20 * log10( abs( H(2:end-1) ) );

figure(1);
semilogx(f,H,'b-','Linewidth',1);
hold on;
semilogx(0.5-f,H,'b-','Linewidth',1);
hold off;
grid;
axis([0.001 0.25 -120 10]);
xlabel('f / f_a');
ylabel('|H| [dB]');
title('Frequenzgang eines Halbband-FIR-Filters mit k=1');
