function ddc_ddc_cfir
% Frequenzgaenge zum Kompensationsfilter CFIR
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Parameter des CIC-Filters
M = 4;
N = 6;

% Frequenzachse des Durchlassbereichs
f = ( 1 : 100 ) / ( 1000 * M );

% CIC-Filter:
% Frequenzgang
H = 1 / M^N * abs( sin( pi * M * f ) ./ sin( pi * f ) ).^N;
% Naeherung fuer den Frequenzgang
H_app = 1 - N * ( M^2 - 1 ) / 6 * ( pi * f ).^2;

% Kompensationsfilter:
% Parameter
alpha = N * ( M^2 - 1 ) / ( 24 * M^2 );
% Koeffizienten
h_C1 = [ -alpha 1+2*alpha -alpha ];
% Frequenzgang
H_C1 = abs( freqz( h_C1, 1, M * f, 1 ) );

figure(1);
plot(M*f,20*log10(H),'b-','Linewidth',2);
hold on;
plot(M*f,20*log10(H_app),'b--','Linewidth',2);
plot(M*f,20*log10(H_C1),'r-','Linewidth',2);
plot(M*f,20*log10(H.*H_C1),'-','Color',[0 0.5 0],'Linewidth',2);
hold off;
grid;
xlabel('f / f_a');
ylabel('|H| [dB]');
title('Frequenzgaenge zum Kompensationsfilter');
legend('CIC','Naeherung fuer CIC','Kompensation',...
       'CIC mit Kompensation','Location','SouthWest');
