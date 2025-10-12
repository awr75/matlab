function ddc_cic_frequenzgang
% Frequenzgang eines CIC-Filters mit M=10
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

M = 10;
f = ( -500 : 500 ) / 1000;
H_M = ( sin( pi * M * f ) / M + 1e-6 ) ./ ( sin( pi * f ) + 1e-6 );
H_M_db = 20 * log10( abs ( H_M ) );

figure(1);
plot(f,H_M_db,'b-','Linewidth',1);
hold on;
plot(f,3*H_M_db,'r-','Linewidth',1);
plot(f,5*H_M_db,'-','Color',[0 0.5 0],'Linewidth',1);
hold off;
grid;
axis([min(f) max(f) -120 10]);
xlabel('f / f_a');
ylabel('|H| [dB]');
title('Frequenzgang von CIC-Filtern mit M=10');
legend('N=1','N=3','N=5');

figure(2);
plot(f,3*H_M_db,'b-','Linewidth',1);
hold on;
for i=-M/2:-1
    plot(f+i/M,3*H_M_db,'b-','Linewidth',1);
end
for i=1:M/2
    plot(f+i/M,3*H_M_db,'b-','Linewidth',1);
end
hold off;
grid;
axis([min(f)/M max(f)/M -80 10]);
xlabel('f / f_a');
ylabel('|H| [dB]');
title('Ueberfalteter Frequenzgang eines CIC-Filters mit M=10 und N=3');
