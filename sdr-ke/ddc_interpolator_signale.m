function ddc_interpolator_signale
% Rekonstruktion eines kontinuierlichen Signals mit einem
% 8-Punkt-Polynom-Interpolator (Farrow-Interpolator)
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% kontinuierliches Eingangssignal x(t)
t = -3 : 0.02 : 24;
x_t = 0.6 * sin( pi * t / 10 ) - 0.4 * cos( t );

% diskretes Signal x[n]
n = t( 1 : 50 : end );
x_n = x_t( 1 : 50 : end );

% Rekonstruktion des Eingangssignals mit einem 8-Punkt-Interpolator
t_i = 0 : 0.02 : 20;
l_t_i = length(t_i);
x_i_t = zeros( 1, l_t_i );
for i = 1 : l_t_i
    % ganzzahliger Anteil der Verschiebung
    delta_n = floor( t_i(i) );
    % fraktionaler Anteil der Verschiebung
    delta = t_i(i) - delta_n;
    % Koeffizienten des Interpolators berechnen
    h_i = interpolator_8(delta);
    % interpolierten Wert berechnen
    x_i_t(i) = x_n( (1:8) + delta_n ) * h_i.';
end

% Interpolationsfehler
e = x_i_t - x_t( 151 : end - 200 );

figure(1);
plot(t,x_t,'b--');
hold on;
plot(n,x_n,'bs','Linewidth',3,'Markersize',2);
hold off;
grid;
axis([0 20 -1 1]);
xlabel('n = t / T_a');
title('Diskretes Eingangssignal');

figure(2);
plot(t_i,x_i_t,'b-','Linewidth',1);
grid;
axis([0 20 -1 1]);
xlabel('n = t / T_a');
title('Interpoliertes Signal');

figure(3);
plot(t_i,e,'b-','Linewidth',1);
grid;
xlabel('n = t / T_a');
title('Interpolationsfehler');
