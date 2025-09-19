function cubic = cubic(d0,col,col_1)
% function cubic.m
% Berechnung der Struktur eines fcc-Gitters
% d0 ist der Abstand vom Ursprung auf der Raumdiagonalen
% col ist die Farbe der Kugeln
% col_1 ist die Farbe der Verbindungslinien
%
% ******************************************************************
% Aufrufstruktur der Unterprogramme und Funktionen:
%
% cubic.m
%   |__ sphere_1.m
%   |__ linie.m
%
% *******************************************************************


if nargin == 0; 
   d0 = 0; col = 'b'; col_1='r';
   % Kugeln blau, Linien rot
end

clf
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

linie(R1,R2,3,col_1)
linie(R1,R3,3,col_1)
linie(R3,R4,3,col_1)
linie(R4,R8,3,col_1)
linie(R8,R7,3,col_1)
linie(R7,R5,3,col_1)
linie(R5,R6,3,col_1)
linie(R6,R8,3,col_1)
linie(R5,R1,3,col_1)
linie(R2,R4,3,col_1)
linie(R2,R6,3,col_1)
linie(R3,R7,3,col_1)

axis equal;		% gleiche Achsen sind wichtig für Darstellung der Kugeln!
light('Position',[0 -2 1]); 	% Position der Lichtquelle
view(-16,19)	% Betrachtungswinkel