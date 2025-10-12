function ueb_schleifenantenne
% Berechnung der Richtcharakteristik einer quadratischen
% magnetischen Schleifenantenne mit der Kantenlaenge l
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
% Laenge einer Kante
l = 0.02;
% Anzahl Segmente
N = 20;
% Entfernung von der Antenne
r = 10;
% Feldwellenwiderstand
Z_0 = 377;
% berechnet wird der Bereich (x > 0, y > 0, z > 0)
% mit einer Winkelaufloesung von 1 Grad
phi_grad   = 0 : 89;
theta_grad = 0 : 90;
phi        = pi * phi_grad / 180;
theta      = pi * theta_grad / 180;
l_phi      = length(phi);
l_theta    = length(theta);
% kartesische Koordinaten berechnen
x = r * sin(theta).' * cos(phi);
y = r * sin(theta).' * sin(phi);
z = r * cos(theta)';
% Oberflaechenelemente berechnen
dA = r^2 * sin(theta) * (phi(2) - phi(1)) * (theta(2) - theta(1));
% Strahlungsleistungsdichte initialisieren
S = zeros(l_theta,l_phi);
% abgestrahlte Leistung initialisieren
P_t = 0;
for i = 1 : l_theta
    for k = 1 : l_phi
        % magnetischen Feldvektor berechnen
        H = H_Vektor(lambda, l, N, x(i,k), y(i,k), z(i));
        % Strahlungsleistungsdichte berechnen
        S(i,k) = Z_0 * real( H' * H );
        % abgestrahlte Leistung berechnen
        P_t = P_t + S(i,k) * dA(i);
    end
end
% abgestrahlte Leistung ueber den ganzen Bereich
P_t = 8 * P_t;
% Strahlungsleistungsdichte einer isotropen Antenne bei gleicher Leistung
S_i = P_t / ( 4 * pi * r^2 );
% Richtcharakteristik
D = S / S_i;
% Richtcharateristik ueber den ganzen Bereich
D = [ D ; flipud( D(1:end-1,:) ) ];
D = repmat(D, 1, 4);
% Richtcharakteristik im 5-Grad-Raster
D_5 = D(1:5:end, 1:5:end);
% Winkel fuer die Richtcharakteristik
phi_5   = pi * (0 : 5 : 355) / 180;
theta_5 = pi * (0 : 5 : 180) / 180;
% karstesische Koordinaten der Richtcharakteristik
x_5 = D_5 .* (sin(theta_5).' * cos(phi_5));
y_5 = D_5 .* (sin(theta_5).' * sin(phi_5));
z_5 = D_5 .* (cos(theta_5).' * ones(1,length(phi_5)));

% Maximum der Richtcharakteristik
D_max = max(max(D));
fprintf(1, 'D_max = %g = %g dB\n', D_max, 10 * log10(D_max));

% Richtcharakteristik anzeigen
figure(1);
colormap([0 0 1;0 0 1]);
mesh(x_5,y_5,z_5);
hold on;
plot3(x_5(19,:),y_5(19,:),-ones(1, 72),'r-','LineWidth',2);
plot3(x_5(:,1),2 * ones(1, 37),z_5(:,1),'r-','LineWidth',2);
plot3(x_5(:,37),2 * ones(1, 37),z_5(:,37),'r-','LineWidth',2);
hold off;
axis equal;
axis([-2 2 -2 2 -1 1]);
xlabel('x');
ylabel('y');
zlabel('z');
title('Richtcharakteristik einer magnetischen Schleifenantenne');

% Berechnung des magnetischen Feldvektors
% (ohne konstante Faktoren)
function H = H_Vektor(lambda, l, N, x, y, z)
% Vektorpotentiale berechnen
delta = 1e-3 * lambda;
A = A_Vektor(lambda, l, N, x, y, z);
A_dx = A_Vektor(lambda, l, N, x + delta, y, z);
A_dy = A_Vektor(lambda, l, N, x, y + delta, z);
A_dz = A_Vektor(lambda, l, N, x, y, z + delta);
% partielle Ableitungen berechnen
dA_dx = (A_dx - A) / delta;
dA_dy = (A_dy - A) / delta;
dA_dz = (A_dz - A) / delta;
% magnetischen Feldvektor bilden
H = [ dA_dy(3) - dA_dz(2) ;
      dA_dz(1) - dA_dx(3) ;
      dA_dx(2) - dA_dy(1) ];

% Berechnung des Vektorpotentials
% (ohne konstante Faktoren)
function A = A_Vektor(lambda, l, N, x, y, z)
% Vektor initialisieren
A = zeros(3, 1);
% Konstante fuer e-Funktionen berechnen
k = - 2i * pi / lambda;
% Segmentierung
l_N = l / (2 * N + 1);
d_n = ( -N : N ) * l_N;
% Abstaende berechnen
d_1 = sqrt( (x - d_n).^2 + (y - l/2)^2  + z^2 );
d_2 = sqrt( (x - l/2)^2  + (y - d_n).^2 + z^2 );
d_3 = sqrt( (x - d_n).^2 + (y + l/2)^2  + z^2 );
d_4 = sqrt( (x + l/2)^2  + (y - d_n).^2 + z^2 );
% x-Komponente berechnen
A(1) = sum( exp(k * d_1) ./ d_1 - exp(k * d_3) ./ d_3 );
% y-Komponente berechnen
A(2) = sum( exp(k * d_4) ./ d_4 - exp(k * d_2) ./ d_2 );
