function ddc_cfir_halbband_filter
% Halbband-Filter mit relativer Bandbreite 0.2 fuer den Einsatz
% im Compensating FIR Filter (CFIR) eines CIC-Filters
%
% Hinweis: Unter der Bandbreite eines Basisband-Filters verstehen wir 
%          grundsaetzlich immer die zweiseitige Bandbreite. Deshalb ist
%          auch hier mit der relativen Bandbreite 0.2 die zweiseitige
%          relative Bandbreite gemeint. Da hier jedoch nur die positive
%          Frequenzachse dargestellt ist, liegt die zugehoerige Bandgrenze
%          bei der halben relativen Bandbreite, also bei 0.1.
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

h3 = halfband_filter(3,68);
h4 = halfband_filter(4,89);
h5 = halfband_filter(5,110);
h6 = halfband_filter(6,130);

[ H3, f ] = freqz( h3, 1, 1000, 1 );
H3 = 20 * log10( abs( H3 ) );
H4 = 20 * log10( abs( freqz( h4, 1, 1000, 1 ) ) );
H5 = 20 * log10( abs( freqz( h5, 1, 1000, 1 ) ) );
H6 = 20 * log10( abs( freqz( h6, 1, 1000, 1 ) ) );

figure(1);
plot(f,H3,'b-','Linewidth',2);
hold on;
plot(f,H4,'r-','Linewidth',2);
plot(f,H5,'-','Color',[0 0.5 0],'Linewidth',2);
plot(f,H6,'k-','Linewidth',2);
plot(f,flipud(H3),'b--','Linewidth',1);
plot(f,flipud(H4),'r--','Linewidth',1);
plot(f,flipud(H5),'--','Color',[0 0.5 0],'Linewidth',1);
plot(f,flipud(H6),'k--','Linewidth',1);
plot([0.1 0.1],[-160 10],'k--','Linewidth',2);
hold off;
grid;
set(gca,'YTick',[-130 -110 -89 -68 0]);
axis([0 0.5 -160 10]);
xlabel('f / f_a');
ylabel('|H| [dB]');
title('Frequenzgaenge von Halbband-Filtern mit relativer Bandbreite 0.2');
legend('k=3','k=4','k=5','k=6');
