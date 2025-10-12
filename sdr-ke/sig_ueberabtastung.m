function sig_ueberabtastung
% Beispiel zur Ueberabtastung eines Sinussignals
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% diskretes Sinus-Signal mit f_a = 1 kHz
f_a = 1000;
t_a = 1 / f_a;
f = 50;
t = -0.3 : t_a : 0.32;
x = sin(2 * pi * f * t);

% Unterabtastung mit M = 4 auf f_a = 250 Hz
M = 4;
t_low = t( 1 : M : end );
x_low = x( 1 : M : end );

% Nullen einfuegen
x_high_null = kron( x_low , [ 1 zeros(1,M-1) ] );
t_high = repmat( t_low , M , 1 );
for i = 2 : M
    t_high(i,:) = t_high(i,:) + ( i - 1 ) * t_a;
end
t_high = reshape( t_high , 1 , [] );

% Tiefpass-Filter
h_tp = M * resampling_filter( M );
l_tp = ( length( h_tp ) - 1 ) / 2;

% Filterung
x_high = conv( x_high_null , h_tp );
x_high = x_high( 1 + l_tp : end - l_tp );

figure(1);
plot(t,x,'b--');
hold on;
plot(t_low,x_low,'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-0.0005 0.0205 -1.1 1.1]);
xlabel('t [s]');
title('Signal mit Abtastrate = 250 Hz');

figure(2);
plot(t,x,'b--');
hold on;
plot(t_high,x_high_null,'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-0.0005 0.0205 -1.1 1.1]);
xlabel('t [s]');
title('Signal mit eingefuegten Nullen');

figure(3);
plot(t,x,'b--');
hold on;
plot(t_high,x_high,'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-0.0005 0.0205 -1.1 1.1]);
xlabel('t [s]');
title('Signal mit Abtastrate = 1 kHz nach der Filterung');
