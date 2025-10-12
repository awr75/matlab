function sdr_nyquist_impulse
% Beispiel fuer die Signalverlaeufe bei einem Nyquist-Filter
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

r = 0.25;
t = -9.99 : 0.05 : 9.96;
g = 1 ./ ( pi * ( 1 - ( 4 * r * t ).^2 ) ) .* ...
    ( 4 * r * cos( (1+r) * pi * t ) + sin( (1-r) * pi * t ) ./ t );
h = sin( pi * t ) ./ ( pi * t ) .* ...
    cos( pi * r * t ) ./ ( 1 - ( 2 *r * t ).^2 );

s = [ 1 1 -1 1 -1 -1 -1 1 ];
x = conv( kron( s, [ 1 zeros(1,19) ] ), g );
x_h = conv( kron( s, [ 1 zeros(1,19) ] ), h );
t_x = min(t) + 0.05 * ( 0 : length(x) - 1 );

figure(1);
plot(t,g,'b-','Linewidth',1);
grid;
axis([-5 5 -0.3 1.2]);
set(gca,'XTick',-5:5);
xlabel('t / T_s');
title('Root Raised Cosine Impuls');

figure(2);
plot(t,h,'b-','Linewidth',1);
hold on;
plot(-5:5,[0 0 0 0 0 1 0 0 0 0 0],'bo','Linewidth',2);
hold off;
grid;
axis([-5 5 -0.3 1.2]);
set(gca,'XTick',-5:5);
xlabel('t / T_s');
title('Raised Cosine Impuls');

figure(3);
plot(t_x,x,'r-','Linewidth',2);
hold on;
for i = 1 : length(s)
    plot(t+i-1,s(i)*g,'b-');
end
hold off;
grid;
axis([-5 12 -1.8 1.8]);
xlabel('t / T_s');
title('Basisbandsignal');
legend('Signal','Impulse');

figure(4);
plot(t_x,x,'r-','Linewidth',1);
hold on;
plot(t_x(1:5:end),x(1:5:end),'rs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([-5 12 -1.8 1.8]);
xlabel('t / T_s');
title('Diskretes Basisbandsignal');

figure(5);
plot(t_x,x_h,'r-','Linewidth',2);
hold on;
for i = 1 : length(s)
    plot(0:length(s)-1,s,'rs','Linewidth',4,'Markersize',3);
    plot(t+i-1,s(i)*h,'b-');
end
hold off;
grid;
axis([-5 12 -1.8 1.8]);
xlabel('t / T_s');
title('Basisbandsignal nach Filterung');
legend('Signal','Symbole','Impulse');
