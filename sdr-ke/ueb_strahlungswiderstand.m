function ueb_strahlungswiderstand
% Strahlungswiderstand einer vertikalen Stabantenne
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Laenge der Antenne bezogen auf die Wellenlaenge
l_lambda = 0.01 : 0.01 : 1;

% Winkel fuer die Integration
steps  = 10000;
theta  = ( 1 : steps - 1 ) * pi / ( 2 * steps );
dtheta = pi / ( 2 * steps );

% Berechnung des Strahlungswiderstands R_S
len = length( l_lambda );
R_S = zeros( 1, len );
for i = 1 : len
   l = l_lambda(i);
   F = ( cos( 2 * pi * l * cos(theta) ) ...
         - cos( 2 * pi * l ) ) ./ sin(theta);
   R_S(i) = 60 * sum( F.^2 .* sin(theta) ) * dtheta;
end

figure(1);
plot(l_lambda,R_S,'b-','Linewidth',1);
grid;
axis([0 1 0 140]);
xlabel('l / lambda')
ylabel('R_S [Ohm]');
title('Strahlungswiderstand einer vertikalen Stabantenne')
