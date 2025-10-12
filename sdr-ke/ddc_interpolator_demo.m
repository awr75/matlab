function ddc_interpolator_demo(step,t_pause)
% ddc_interpolator_demo(step,t_pause)
%
% Rekonstruktion eines kontinuierlichen Signals mit einem
% 8-Punkt-Polynom-Interpolator (Farrow-Interpolator)
%
%    step    - Schrittweite fuer die Interpolation (>= 0)
%    t_pause - Pause zwischen den Schritten (0.01 ... 1)
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

if nargin < 1
    step = pi / 10;
end
if nargin < 2
    t_pause = 0.2;
end
t_pause = min( max( t_pause, 0.01 ), 1 );
if step <= 0
    error('Schrittweite muss groesser Null sein');
end

% kontinuierliches Eingangssignal x(t)
t = -3 : 0.02 : 24;
x_t = 0.6 * sin( pi * t / 10 ) - 0.4 * cos( t );

% diskretes Signal x[n]
n = t( 1 : 50 : end );
x_n = x_t( 1 : 50 : end );

figure(1);
s = get(0,'Screensize');
set( gcf, 'Position', [ 0.2*s(3) 0.2*s(4) 0.6*s(3) 0.6*s(4) ] );
subplot(2,1,1);
plot(t,x_t,'k-');
hold on;
plot(n,x_n,'ks','Linewidth',4,'Markersize',2);
h1 = plot(0,0,'co','Linewidth',4,'Markersize',4);
h2 = plot(0,0,'ro','Linewidth',4,'Markersize',4);
hold off;
grid;
axis([-3 23 -1 1]);
xlabel('n = t / T_a');
title('Signal');
subplot(2,1,2);
h3 = plot(0:7,zeros(1,8),'ks','Linewidth',4,'Markersize',3);
grid;
axis([0 26 -0.4 1.2]);
h4 = gca;
set( h4, 'XTick', 0 : 7 );
xlabel('n');
h5 = title('Interpolator-Koeffizienten');

n_pos = 0;
delta = 0;
first = 1;
while n_pos < 20
    % Indices der relevanten Werte des Eingangssignals
    idx = n_pos + ( 1 : 8 );
    % Koeffizienten des Interpolators berechnen
    h_i = interpolator_8( delta );
    % interpolierten Wert berechnen
    x_i = x_n(idx) * h_i.';
    try
        set( h1, 'XData', n(idx) );
        set( h1, 'YData', x_n(idx) );
        set( h2, 'XData', n_pos + delta );
        set( h2, 'YData', x_i );
        set( h3, 'YData', h_i );
        set( h4, 'XLim', [ 0 26 ] - n_pos );
        set( h5, 'String', sprintf( ...
             'Interpolator-Koeffizienten (pos = %d , delta = %.4f)', ...
             n_pos, delta ) );
        drawnow;
    catch
        break;
    end
    if first == 1
        first = 0;
        pause(1);
    else
        pause(t_pause);
    end
    % Position anpassen
    delta  = delta + step;
    n_step = floor( delta );
    delta  = delta - n_step;
    n_pos  = n_pos + n_step;
end
