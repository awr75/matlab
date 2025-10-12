function ueb_leitung
% Daempfung einer Koaxialleitung
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Daempfungskonstanten der Leitung
c_1 = 3e-6;
c_2 = 0.5e-10;

% Frequenzachse
f = 10.^(7:0.05:10);

% Daempfungsbelag
alpha_L = c_1 * sqrt( f ) + c_2 * f;

figure(1);
loglog(f,10*log10(exp(alpha_L)),'b-','Linewidth',2);
hold on;
loglog(f,10*log10(exp(c_1*sqrt(f))),'b--','Linewidth',1);
loglog(f,10*log10(exp(c_2*f)),'b--','Linewidth',1);
hold off;
grid;
axis([1e7 1e10 0.03 5]);
xlabel('f [Hz]');
ylabel('alpha_L [dB/m]');
title('Daempfungsbelag einer typischen Koaxialleitung');

% Auswertung ueber die Laenge
f = 10.^(7:10);
l = 10.^(-1:0.05:1);
color=[0 0 1;1 0 0;0 0.5 0;0 0 0];
figure(2);
for i = 1 : length(f);
    alpha_L = c_1 * sqrt( f(i) ) + c_2 * f(i);
    loglog(l,10*log10(exp(alpha_L*l)),'-','Color',color(i,:),'Linewidth',1);
    hold on;
end
hold off;
grid;
axis([0.1 10 0.001 100]);
xlabel('l [m]');
ylabel('L_L [dB]');
title('Daempfung einer typischen Koaxialleitung');
legend('10 MHz','100 MHz','1 GHz','10 GHz','Location','SouthEast');
