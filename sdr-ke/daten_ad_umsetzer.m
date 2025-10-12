function daten_ad_umsetzer
% Quantisierung eines A/D-Umsetzers
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

t = ( 0 : 10000 ) / 10000;
x = 0.999 * sin( 2 * pi * t );
n = 16;
q = 2 / n;
x_q = q * ( round( x / q - 0.5 ) + 0.5 );
n_q = x_q - x;

figure(1);
plot(t,x,'b-','Linewidth',1);
hold on
plot(t,x_q,'r-','Linewidth',1);
hold off;
grid;
axis([0 1 -1 1]);
set(gca,'YTick',q*((-n/2:n/2-1)+0.5));
set(gca,'YTickLabel',0:n-1);
set(gca,'XTick',[]);
ylabel('Ausgabewert');
title('Quantisierung eines Sinussignals');

figure(2);
plot(t,n_q,'b-');
grid;
axis([0 1 -0.08 0.08]);
set(gca,'YTick',0.5*q*[-1 0 1]);
set(gca,'YTickLabel',{'-q/2','0','q/2'});
set(gca,'XTick',[]);
ylabel('Quantisierungsfehler');
title('Quantisierungsfehler bei einem Sinussignal');
