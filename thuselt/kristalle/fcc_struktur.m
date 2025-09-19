% M-File fcc_struktur.m
% Berechnung der Struktur eines fcc-Gitters
%
% ******************************************************************
% Aufrufstruktur der Unterprogramme und Funktionen:
%
% fcc_struktur.m
%   |__ fcc.m
%   |     |__ sphere_1.m
%   | 
%   |__ fccgitter.m
%         |__ linie.m
%
% *******************************************************************

color1 = [69/255 80/255 135/255];	% Farbe für Kugeln
color11 = 'k';								% Farbe für Linien 

clf
d0 = 0; 
fcc(d0,color1);				% Gitteratome	
fccgitter(d0,color11);		% Kanten

view(-16,19)