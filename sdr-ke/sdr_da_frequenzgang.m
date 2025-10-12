function sdr_da_frequenzgang
% Frequenzgang des Mittelungsfilters bei der D/A-Umsetzung
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Verlauf des Frequenzgangs
f = ( -5 : 0.01 : 5 ) + 1e-6;
h = 20 * log10( abs( sin( pi * f ) ./ ( pi * f ) ) );

% Naeherung durch Parabel
f_1 = ( -0.5 : 0.01 : 0.5 ) + 1e-6;
h_1 = 20 * log10( 1 - ( pi * f_1 ).^2 / 6 );

figure(1);
plot(f,h,'b-','Linewidth',1);
grid;
axis([-5 5 -40 1]);
xlabel('f / f_a_,_i')
ylabel('|H_D_A| [dB]');
title('Frequenzgang des Mittelungsfilters');

figure(2);
plot(f,h,'b-','Linewidth',1);
hold on;
plot(f_1,h_1,'r-','Linewidth',1);
hold off;
grid;
axis([-0.5 0.5 -5 0.5]);
xlabel('f / f_a_,_i')
ylabel('|H_D_A| [dB]');
title('Frequenzgang des Mittelungsfilters');
legend('Frequenzgang','Parabel-Naeherung','Location','SouthEast');
