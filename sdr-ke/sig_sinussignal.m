function sig_sinussignal
% Darstellung eine Sinus-Signals als quasi-kontinuierliches
% und als diskretes Signal
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% diskretes Sinus-Signal
f_a = 1000;
t_a = 1 / f_a;
f = 50;
t = 0 : t_a : 0.02;
x = sin(2 * pi * f * t);

figure(1);
plot(t,x,'b-','Linewidth',1);
hold on;
plot(t,x,'bs','Linewidth',3,'Markersize',2);
hold off;
grid on;
axis([min(t) max(t) -1.1 1.1]);
xlabel('t [s]');
title('Darstellung eines Sinus-Signals');
