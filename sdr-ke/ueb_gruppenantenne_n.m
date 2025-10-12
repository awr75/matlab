function ueb_gruppenantenne_n
% Berechnung der Richtcharakteristik einer Gruppenantenne
% mit N vertikalen Stabantennen der Laenge lambda/2
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2014
%------------------------------------------------

close all;

% Frequenz
f = 2.4e9;
% Lichtgeschwindigkeit
c = 3e8;
% Wellenlaenge
lambda = c / f;
% Abstand der Elemente
d_E = lambda / 4;
% Phasenverschiebung zwischen den Elementen
delta = pi/2;
% horizontale Richtcharakteristik berechnen (2/3/4 Elemente)
[D_1, phi] = D_Gruppe(lambda, d_E, delta, 2);
D_2 = D_Gruppe(lambda, d_E, delta, 3);
D_3 = D_Gruppe(lambda, d_E, delta, 4);

% Richtcharakteristiken anzeigen
figure(1);
h = polar(phi,D_1,'b-');
set(h,'LineWidth',2);
title('Gruppenantenne mit 2 Elementen');

figure(2);
h = polar(phi,D_2,'b-');
set(h,'LineWidth',2);
title('Gruppenantenne mit 3 Elementen');

figure(3);
h = polar(phi,D_3,'b-');
set(h,'LineWidth',2);
title('Gruppenantenne mit 4 Elementen');

% horizontale Richtcharakteristik eines linearen Arrays mit
% N vertikalen Stabantennen der Laenge lambda/4 berechnen
function [D_xy, phi] = D_Gruppe(lambda, d_E, delta, N)
% Maximum der Richtcharakteristik eines Elements in der xy-Ebene
D_T_max = 3.3;
% horizontale Richtcharakteristik berechnen
phi  = pi * ( 0 : 360) / 180;
k_i  = delta - 2 * pi * d_E * cos(phi) / lambda;
n_i  = ( 0 : N - 1 ).';
D_xy = D_T_max * abs( sum( exp( j * n_i * k_i ) ) ).^2 / N;
