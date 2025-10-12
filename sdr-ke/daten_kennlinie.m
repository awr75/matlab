function daten_kennlinie
% Nichtlineare Kennlinie
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Parameter
A  = 10;
c3 = 0.3;
c5 = 0.6;

% Kennlinie
x = -1 : 0.01 : 1;
[ y , ymax, xmax ] = nonlinear( x, A, c3, c5 );

% Einton-Signal
l_fft = 64;
l_ov = 7;
xs = sin( 2 * pi * ( 0 : l_fft - 1 ) / l_fft );
xa = 10.^( -2 : 0.01 : 1 );
l_xa = length(xa);
ys = zeros( l_xa, length(xs) );
ya = zeros( l_xa, l_ov );
for i = 1 : l_xa
    ys( i, : ) = nonlinear( xa(i) * xs, A, c3, c5 );
    yf = 2 * abs( fft( ys( i, : ) ) ) / l_fft;
    ya( i, : ) = yf( 2 : 2 : 2 * l_ov );
end
ys = [ ys ys(:,1) ];
ts = ( 0 : l_fft ) / l_fft;

figure(1);
plot(x,y,'b-','Linewidth',2);
hold on;
plot(x,A*x,'b--','Linewidth',2);
plot([-1 xmax],[ymax ymax],'k--');
plot([xmax xmax],[-6 ymax],'k--');
plot([-xmax -xmax],[-6 -ymax],'k--');
hold off;
grid;
axis([-1 1 -6 6]);
xlabel('x');
ylabel('y');
title('Nichtlineare Kennlinie');
legend('Kennlinie','Gerade','Location','SouthEast');

figure(2);
loglog(xa,ya(:,1),'b-','Linewidth',2);
hold on;
for i=2:l_ov
    loglog(xa,ya(:,i),'r-','Linewidth',2);
end
hold off;
grid;
axis([0.01 10 1e-6 10]);
xlabel('Eingangsamplitude');
ylabel('Ausgangsamplitude');
title('Amplituden der Grundwelle und der Oberwellen');
legend('Grundwelle','Oberwellen','Location','SouthEast');

figure(3);
plot(ts,ys(101,:),'b-','Linewidth',2);
hold on;
plot(ts,ys(151,:),'r-','Linewidth',2);
plot(ts,ys(201,:),'g-','Color',[0 0.5 0],'Linewidth',2);
plot(ts,ys(301,:),'k-','Linewidth',2);
hold off;
grid;
axis([0 1 -6 6]);
title('Verlauf der Ausgangssignale');
legend('Amplitude = 0.1','Amplitude = 0.316',...
       'Amplitude = 1','Amplitude = 10');
