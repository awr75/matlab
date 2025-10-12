function sdr_gauss_filter
% Impulsantwort und Uebertragungsfunktion eines idealen Gauss-Filters
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

t = -0.5 : 0.005 : 0.5;
g = sqrt( 2 * pi / log(2) ) * exp( - 2 * ( pi * t ).^2 / log(2) );
f = -4 : 0.05 : 4;
G = 20 * log10( exp( - log(2) * f.^2 / 2 ) );

figure(1);
plot(t,g,'b-','Linewidth',1);
grid;
axis([-0.5 0.5 0 3.2]);
set(gca,'XTick',-0.4:0.2:0.4);
xlabel('Bg * t');
title('Impulsantwort eines Gauss-Filters');

figure(2);
plot(f,G,'b-','Linewidth',1);
grid;
axis([-4 4 -50 5]);
xlabel('f / Bg');
ylabel('G [dB]');
title('Frequenzgang eines Gauss-Filters');
