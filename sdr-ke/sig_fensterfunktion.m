function sig_fensterfunktion
% Fensterung einer Sinusfunktion
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

f_a = 8000;
t_a = 1 / f_a;
f_0 = 50;
t = 0 : t_a : 0.2;
f = f_0 * (1 + 10 * t);
x = sin(2 * pi * cumsum(f) / f_a);

l_w = 2 * floor(length(x) / 4);
w   = blackman_window(l_w);
t_m = 0.1;
i_m = floor(t_m * f_a);
w_t = zeros(1,length(t));
w_t(i_m - l_w/2 : i_m + l_w/2 - 1) = w;

figure(1);
plot(t,x,'b','Linewidth',1);
axis([min(t) max(t) -1.1 1.1]);
grid on;
xlabel('t [s]');
title('Sweep-Signal');

figure(2);
plot(t,w_t,'b-','Linewidth',1);
axis([min(t) max(t) -0.1 1.1]);
grid on;
xlabel('t [s]');
title('Fensterfunktion mit t_M = 0.1 sec');

figure(3);
plot(t,x .* w_t,'b-','Linewidth',1);
axis([min(t) max(t) -1.1 1.1]);
grid on;
xlabel('t [s]');
title('Gefenstertes Signal');
