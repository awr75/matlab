function ddc_cic_bandbreite
% Bandbreite eines CIC-Filters als Funktion der Alias-Daempfung
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Parameter des Filters
M = 10;

% Bandbreite
B = ( 1 : 100 ) / ( 100 * M );

% Alias-Daempfung
D_a = 20 * log10( sin( pi * ( 1 / M - B / 2 ) ) ./ ...
                  sin( pi * B / 2 ) );

figure(1);
plot(B,3*D_a,'b-','Linewidth',1);
hold on;
plot(B,4*D_a,'r-','Linewidth',1);
plot(B,5*D_a,'-','Color',[0 0.5 0],'Linewidth',1);
plot(B,6*D_a,'k-','Linewidth',1);
hold off;
grid;
axis([0 1/M 0 120]);
xlabel('B / f_a');
ylabel('D_a [dB]');
title('Alias-Daempfung eines CIC-Filters mit M=10');
legend('N=3','N=4','N=5','N=6');
