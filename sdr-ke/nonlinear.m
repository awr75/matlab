function [y,ymax,xmax] = nonlinear(x,a,c3,c5)
% [y,ymax,xmax] = nonlinear(x,a,c3,c5)
%
% Signaluebertragung ueber eine nichtlineare Kennlinie
%
%   y    - Ausgangssignal
%   ymax - y-Wert an der Grenze des Hauptbereichs
%   xmax - x-Wert an der Grenze des Hauptbereichs
%   x    - Eingangssignal
%   a    - lineare Verstaerkung
%   c3   - Kennlinienkoeffizient 3.Ordnung
%   c5   - Kennlinienkoeffizient 5.Ordnung
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

% Daten der Kennlinie
xmax = sqrt((sqrt(9*c3^2+20*c5)-3*c3)/(10*c5));
ymax = a*(xmax-c3*xmax^3-c5*xmax^5);

% Berechnung des Ausgangssignals
y = a*(x-c3*x.^3-c5*x.^5);
y(x > xmax)  = ymax;
y(x < -xmax) = -ymax;
