function ddc_halbband_filter
% Frequenzgaenge von Halbband-FIR-Filtern mit k = 2,...,5
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Sperrdaempfung in dB
a = 80;

% Frequenzgaenge berechnen
h2 = halfband_filter( 2, a );
[ H2, f ] = freqz( h2, 1, 1000, 1 );
H2 = 20 * log10( abs( H2 ) );
h3 = halfband_filter( 3, a );
H3 = 20 * log10( abs( freqz( h3, 1, 1000, 1 ) ) );
h4 = halfband_filter( 4, a );
H4 = 20 * log10( abs( freqz( h4, 1, 1000, 1 ) ) );
h5 = halfband_filter( 5, a );
H5 = 20 * log10( abs( freqz( h5, 1, 1000, 1 ) ) );

figure(1);
plot(f,H2,'b-','Linewidth',1);
hold on;
plot(f,H3,'r-','Linewidth',1);
plot(f,H4,'-','Color',[0 0.5 0],'Linewidth',1);
plot(f,H5,'k-','Linewidth',1);
plot(0.5-f,H2,'b-','Linewidth',1);
plot(0.5-f,H3,'r-','Linewidth',1);
plot(0.5-f,H4,'-','Color',[0 0.5 0],'Linewidth',1);
plot(0.5-f,H5,'k-','Linewidth',1);
hold off;
grid;
axis([0 0.25 -120 10]);
xlabel('f / f_a');
ylabel('|H| [dB]');
title('Frequenzgaenge von Halbband-FIR-Filtern');
legend('k=2','k=3','k=4','k=5','Location','SouthEast');
