function fcc = fcc(d0,col)
% function fcc.m
% Gitteratome (Kugeln) im kubisch flächenzentrierten Gitter
% d0 ist der Abstand vom Ursprung auf der Raumdiagonalen
% col ist die Farbe der Kugeln
% ruft Funktion sphere_1.m auf

if nargin == 0; 
   d0 = 0; col = 'b';	% Kugeln blau
end

a = 10;
r = .1;

u = [d0,d0,d0]; % Koordinaten des Ursprungs als (u,u,u)

% *************************************
% Eckpunkte und Verbindungslinien
% *************************************
R1 = [0,0,0]+u;
R2 = [0,0,1]+u;
R3 = [0,1,0]+u;
R4 = [0,1,1]+u;
R5 = [1,0,0]+u;
R6 = [1,0,1]+u;
R7 = [1,1,0]+u;
R8 = [1,1,1]+u;


sphere_1(a*R1,r,col); hold on;
sphere_1(a*R2,r,col)
sphere_1(a*R3,r,col)
sphere_1(a*R4,r,col)
sphere_1(a*R5,r,col)
sphere_1(a*R6,r,col)
sphere_1(a*R7,r,col)
sphere_1(a*R8,r,col)


% *****************************************
% Flächenmittelpunkte und Flächendiagonalen
% *****************************************
Ra = [.5,.5,0]+u;		% Mitte untere Fläche
Rb = [.5,0,.5]+u;		% Mitte vordere Fläche
Rc = [0,.5,.5]+u;		% Mitte linke Fläche
Rd = [.5,.5,1]+u;		% Mitte obere Fläche
Re = [.5,1,.5]+u;		% Mitte hintere Fläche
Rf = [1,.5,.5]+u;		% Mitte rechte Fläche
sphere_1(a*Ra,r,col)
sphere_1(a*Rb,r,col)
sphere_1(a*Rc,r,col)
sphere_1(a*Rd,r,col)
sphere_1(a*Re,r,col)
sphere_1(a*Rf,r,col)

axis equal;
light('Position',[0 -2 1]);

