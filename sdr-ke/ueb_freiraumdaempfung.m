function ueb_freiraumdaempfung
% Freiraumdaempfung
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Entfernung in Meter
r = [ 10.^([0:0.1:2 3:7]) 3.6e7 ];

% Betriebsfrequenz in Hz
f = 10.^(7:10);

% Lichtgeschwindigkeit in m/s
c = 3e8;

figure(1);
color=[0 0 1;1 0 0;0 0.5 0;0 0 0];
for i = 1 : length(f)
    L_F = ( 4 * pi * r * f(i) / c ).^2;
    lambda = c / f(i);
    idx = find( r > lambda ); 
    semilogx(r(idx),10*log10(L_F(idx)),'-','Color',color(i,:),'Linewidth',1);
    hold on;
end
hold off;
grid;
axis([1 3.5e7 20 220]);
set(gca,'XTick',10.^(0:7));
xlabel('r [m]');
ylabel('L_F [dB]');
title('Freiraumdaempfung');
legend('10 MHz','100 MHz','1 GHz','10 GHz','Location','SouthEast');
