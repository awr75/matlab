% M-File zinkblende.m
% Berechnung der Struktur eines Zinkblende-Gitters
%
% ******************************************************************
% Aufrufstruktur der Unterprogramme und Funktionen:
%
% zinkblende.m
%   |__ fcc.m
%   |     |__ sphere_1.m
%   | 
%   |__ fccgitter.m
%   |     |__ linie.m
%   | 
%   |__ bind.m
%   |     |__ tetraeder.m
%   |           |__ linie.m
%   | 
%   |__ tetraeder.m
%         |__ linie.m
%
% *******************************************************************

aa = input('Mit Darstellung der Kanten? ja (1) / nein (2) (Default: ja  ) ');
if isempty(aa), aa = 1; end   
bb = input('Mit Darstellung der Bindungen am vorderen Tetreader (1) / alle Bindungen (2)? Keine? (3) (Default: ja   ) ');
if isempty(bb), bb = 1; end   

color1 = [69/255 80/255 135/255];	% Farbe für Kugeln 1. Gitter
color2 = [41/255 58/255 69/255];		% Farbe für Kugeln 2. Gitter
color11 = 'k';	% Farbe für Linien 1. Gitter
color22 = 'm';		% Farbe für Linien 2. Gitter

clf
d0 = 0; % 1. Gitter
fcc(d0,color1);
if aa == 1
	fccgitter(d0,color11);
end

d0 = 1/4; % 2. Gitter
fcc(d0,color2);

if aa == 1
	fccgitter(d0,color22);
end

if bb == 2
	col = 'c';
   bind(col);
elseif bb == 1
	R = [0,0,0];
	col = 'c';
	tetraeder(R,col)
end
view(-16,19)