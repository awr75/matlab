function bind = bind(col)
% function bind.m
% Chemische Bindungen im Zinkblende-Gitter
% u bezeichnet die Koordinaten des Ursprungs
%
% ***************************************************
% Aufrufstruktur der Unterprogramme und Funktionen:
%
% bind.m
%   |__ tetraeder.m
%         |__ linie.m
%
% ***************************************************


if nargin == 0; 
   col='k';
   % Linien schwarz
end

u1 = .25*[1,1,1];

% *************************************
% Eckpunkte und Verbindungslinien
% *************************************
% doppelte Indizes gehören jeweils zum Gitter der zweiten Komponenten
R1 = [0,0,0];
R11 = R1+ u1;
R2 = [0,0,1];
R22 = R2+ u1;
R3 = [0,1,0];
R33 = R3+ u1;
R4 = [0,1,1];
R44 = R4+ u1;
R5 = [1,0,0];
R55 = R5+ u1;
R6 = [1,0,1];
R66 = R6+ u1;
R7 = [1,1,0];
R77 = R7+ u1;
R8 = [1,1,1];
R88 = R8+ u1;

% *****************************************
% Flächenmittelpunkte und Flächendiagonalen
% *****************************************
Ra = [.5,.5,0];		% Mitte untere Fläche
Rb = [.5,0,.5];		% Mitte vordere Fläche
Rc = [0,.5,.5];		% Mitte linke Fläche
Rd = [.5,.5,1];		% Mitte obere Fläche
Rdd = Rd + u1;
Re = [.5,1,.5];		% Mitte hintere Fläche
Ree = Re + u1;
Rf = [1,.5,.5];		% Mitte rechte Fläche
Rff = Rf + u1;

% ***************
% Ganze Tetraeder
% ***************
% Tetraeder vorn unten links
R = [0,0,0];
tetraeder(R,col)

% Tetraeder hinten oben links
R = [0,0.5,0.5];
tetraeder(R,col)

% Tetraeder vorn oben rechts
R = [0.5,0,0.5];
tetraeder(R,col)

% Tetraeder hinten unten rechts
R = [0.5,0.5,0];
tetraeder(R,col)

% ********************
% Teile von Tetraedern
% ********************
% hinten unten links
linie(R33,R3,6,col);
linie(R33,Re,6,col)

% hinten oben links
linie(R44,R4,6,col);

% vorn unten rechts
linie(R55,R5,6,col);
linie(R55,Rf,6,col)

% vorn oben links
linie(R22,R2,6,col);
linie(R22,Rd,6,col);

% vorn oben rechts
linie(R66,R6,6,col);

% hinten oben rechts
linie(R88,R8,6,col)
linie(R8,Rdd,6,col)
linie(R8,Ree,6,col)
linie(R8,Rff,6,col)
linie(Rf,Rff,6,col)
linie(Rd,Rdd,6,col)
linie(Re,Ree,6,'m')

% vorn unten rechts
linie(R55,R5,6,col)
linie(R55,Rf,6,col)

% hinten unten rechts
linie(R77,R7,6,col)

axis equal;

