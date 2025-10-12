function sdr_preselector_kw
% Berechnung von Preselector-Filtern fuer die Kurzwelle
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% 80-Meter-Band (3.5...3.8 MHz)
[h1,f1] = pre(3.65,0.4,1.5);

% 40-Meter-Band (7...7.2 MHz)
[h2,f2] = pre(7.1,0.3,1.5);

% 30-Meter-Band (10...10.2 MHz)
[h3,f3] = pre(10.1,0.3,1.5);

% 20-Meter-Band (14...14.35 MHz)
[h4,f4] = pre(14.175,0.45,1.5);

figure(1);
plot(f1,h1,'b-','Linewidth',1);
hold on;
plot(f2,h2,'r-','Linewidth',1);
plot(f3,h3,'-','Color',[0 0.5 0],'Linewidth',1);
plot(f4,h4,'k-','Linewidth',1);
hold off;
grid;
axis([1 20 -60 5]);
xlabel('f [MHz]');
ylabel('|H| [dB]');
title('Verfuegbarer Gewinn der Preselector-Filter');
legend('80 m','40 m','30 m','20 m');

function [h,f] = pre(f_m,b,k)
f_r = sqrt( f_m^2 - b^2 / 4 );
q_r = sqrt(2) * k *f_r / b;
f = 10.^(0:0.001:1.5);
v = q_r * ( f / f_r - f_r ./ f );
h = 10 * log10( k^2 ./ ( (1+k^2)^2 + (2-2*k^2)*v.^2 + v.^4) ) + 6;
