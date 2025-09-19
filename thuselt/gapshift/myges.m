function myges = myges(n, substanz, T, donorflag)
% Funktion myges = myges(n, substanz, T, donorflag)
% Berechnung des störstellenbedingten Beitrags zur Gapshift für eine Dichte
% in Abhängigkeit von der Dotierung und der Temperatur
% einfaches Programm ohne numerische Ausgaben
%
% Quelle: Thuselt, Rösler, phys.stat.sol. (b) 130, K139 (1985)
%
% - n ist die Elektronenkonzentration
% - substanz ist das m-File des Halbleitermaterials, in Hochkomma eingeschlossen
%     (Default: 'Silizium')
% - Wenn donorflag = 1, dann Elektronen und Löcher vertauscht, also Akzeptordotierung
%     Dotierung mit Donatoren angenommen, dadurch Elektronendichte vorgegeben
%     Löcherdichte wird nach MWG berechnet
%     In allen anderen Fällen Donatordotierung angenommen (Default) 
%       donorflag kann für Donatordotierung auch weggelassen werden
% - T ist die abolute Temperatur (Default: 300 K)
% - Wenn plotflag = 1, dann Plot doppelt logarithmisch und numerische Ausgabe von Daten
%     Wenn plotflag = 2, dann Plot halblogarithmisch und numerische Ausgabe von Daten
%     Wenn plotflag = 0, werden keine Daten ausgegeben
% Das Programm ruft die folgenden Funktionen auf:
%		f_myxce(n, substanz, T, donorflag);   
%		f_myxch(n, substanz, T, donorflag);   
%		f_myie(n, substanz, T, donorflag);   
%		f_myih(n, substanz, T, donorflag);

% Wenn Akzeptordotierung vorgegeben (p-Material, d.h. donatorflag = 1),
%       dann wird vertauscht
%       Ryde <-> Rydh
%       abe <-> abh

%*********************************************************
% Allgemeines
if nargin < 4, donorflag = 0; end
if nargin < 3, T = 300; end
if nargin < 2, substanz = 'Silizium'; end
if nargin < 1, nmax = 1e21; end
if strcmpi(substanz,'Si'); substanz = 'Silizium'; end
if strcmpi(substanz,'Ge'); substanz = 'Germanium'; end

n = n(:)';
% *************************************************
% Ergebnisse
% *************************************************
myxce = f_myxce(n, substanz, T, donorflag);  %Austausch-Korrelation, LB 
myxch = f_myxch(n, substanz, T, donorflag);  %Austausch-Korrelation, VB   
myie  = f_myie(n, substanz, T, donorflag);   %Störstellen, LB  
myih  = f_myih(n, substanz, T, donorflag);   %Störstellen, VB
myges = myxce + myxch + myie + myih;

