function ueb_gruppenantenne
% Berechnung der Richtcharakteristik einer Gruppenantenne
% mit zwei vertikalen Stabantennen der Laenge lambda/2
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2014
%------------------------------------------------

close all;

% Frequenz
f = 434e6;
% Lichtgeschwindigkeit
c = 3e8;
% Wellenlaenge
lambda = c / f;
% Entfernung von der Antenne
r = 10;
% horizontale Richtcharakteristik ohne Phasenverschiebung
[D_1, phi] = D_Gruppe(r, lambda, lambda/4, 0);
D_2 = D_Gruppe(r, lambda, lambda/2, 0);
D_3 = D_Gruppe(r, lambda, 3 * lambda/4, 0);
D_4 = D_Gruppe(r, lambda, lambda, 0);

% horizontale Richtcharakteristik mit Phasenverschiebung
D_5 = D_Gruppe(r, lambda, lambda/4, pi/2);
D_6 = D_Gruppe(r, lambda, lambda/4, -pi/2);

% Richtcharakteristiken anzeigen
figure(1);
h = polar(phi,D_1,'b-');
set(h,'LineWidth',2);

figure(2);
h = polar(phi,D_2,'b-');
set(h,'LineWidth',2);

figure(3);
h = polar(phi,D_3,'b-');
set(h,'LineWidth',2);

figure(4);
h = polar(phi,D_4,'b-');
set(h,'LineWidth',2);

figure(5);
h = polar(phi,D_5,'b-');
set(h,'LineWidth',2);

figure(6);
h = polar(phi,D_6,'b-');
set(h,'LineWidth',2);

% horizontale Richtcharaktersitik der Gruppe berechnen
function [D_xy, phi] = D_Gruppe(r, lambda, d_E, delta)
% Maximum der Richtcharakteristik eines Elements in der xy-Ebene
D_T_max = 3.3;
% Feldwellenwiderstand
Z_0 = 377;
% Sendeleistung eines Elements
P_T = 1;
% Betrag des elektrischen Feldes eines Elementes in der xy-Ebene
E_0 = sqrt( P_T * D_T_max * Z_0 / (4 * pi) );
% Winkel in der xy-Ebene
phi = pi * ( 0 : 360) / 180;
% kartesische Koordinaten
x = r * cos(phi);
y = r * sin(phi);
% Abstaende berechnen
r_1 = sqrt( (x - d_E/2).^2 + y.^2 );
r_2 = sqrt( (x + d_E/2).^2 + y.^2 );
% elektrisches Feld in der xy-Ebene berechnen
k = - 2i * pi / lambda;
E_z = E_0 * ( exp( k * r_1 ) ./ r_1 + exp( k * r_2 + 1i * delta ) ./ r_2 );
% Strahlungsleistungsdichte in der xy-Ebene berechnen
S_xy = abs(E_z).^2 / Z_0;
% Strahlungsleistungsdichte einer isotropen Antenne
S_i = 2 * P_T / ( 4 * pi * r^2 );
% horizontale Richtcharakteristik berechnen
D_xy = S_xy / S_i;
