function fccgitter = fccgitter(d0,col)
% function fccgitter.m
% Verbindungslinien zwischen den Gitterpunkten im Zinkblende-Gitters
% d0 ist der Abstand vom Ursprung auf der Raumdiagonalen
% col ist die Faerbe der Verbindungslinien
% ruft Funktion linie.m auf


if nargin == 0; 
   d0 = 0; col='r';
   % Kugeln kupferfarben, Linien rot
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


linie(R1,R2,3,col); hold on;
linie(R1,R3,3,col)
linie(R3,R4,3,col)
linie(R4,R8,3,col)
linie(R8,R7,3,col)
linie(R7,R5,3,col)
linie(R5,R6,3,col)
linie(R6,R8,3,col)
linie(R5,R1,3,col)
linie(R2,R4,3,col)
linie(R2,R6,3,col)
linie(R3,R7,3,col)

% *****************************************
% Flächenmittelpunkte und Flächendiagonalen
% *****************************************

linie(R1,R4,2,col); linie(R2,R3,2,col); % linke Fläche
linie(R1,R6,2,col); linie(R2,R5,2,col); % vordere Fläche
linie(R1,R7,2,col); linie(R3,R5,2,col); % untere Fläche 
linie(R5,R8,2,col); linie(R6,R7,2,col); % rechte Fläche
linie(R4,R7,2,col); linie(R3,R8,2,col); % hintere Fläche
linie(R2,R8,2,col); linie(R6,R4,2,col); % obere Fläche


axis equal;
light('Position',[0 -2 1]);

