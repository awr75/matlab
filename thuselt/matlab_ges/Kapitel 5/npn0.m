% Unterprogramm npn0.m 
% Konstanten und Parameter zum Programm npn_basis.m oder npn_emit.m
Silizium
% Laden von Halbleiterparametern und allgemeinen Konstanten
% (silizium.m ruft konstanten.m auf)
e0 = eps0/100; % Umrechnung der Maßeinheiten in cm

% verschiedene Parameter 
A = 1.0e-4; 	% Querschnittsfläche A in cm^2 
WB = 2.5e-4; 	% Basisbreite WB in cm
               % passt ungefähr zu BCY 58 (Siemens)
T = 300;

% Störstellenkonzentrationen 
NE = 1.0e18; 	% Emitter
NB = 1.5e16; 	% Basis
NC = 1.5e15; 	% Kollektor
type_npn = 1;       % Wenn type_npn = 1, dann npn-Transistor, sonst pnp-Transistor

% Störstellenkonzentrationen 
NE = 5e17; 	% Emitter
NB = 1e17; 	% Basis
NC = 1.0e16; 	% Kollektor
% Minoritätsträgerdichten
pE0 = ni_0^2/NE; 
nB0 = ni_0^2/NB; 
pC0 = ni_0^2/NC; 

% Beweglichkeiten
if type_npn == 1    % npn-Transistor
   myE = myh(NE,T);
   myB = mye(NB,T);
   myC = myh(NC,T);
else           % npn-Transistor
   myE = mye(NE,T);
   myB = myh(NB,T);
   myC = mye(NC,T);
end

% Lebensdauern
TauE = 1.0e-7; 
TauB = 1.0e-6; 
TauC = 1.0e-6;
% Diffusionskoeffizienten 
DE = kT*myE;  
DB = kT*myB; 
DC = kT*myC;
% Diffusionslängen 
LE = sqrt(DE*TauE); 
LB = sqrt(DB*TauB); 
LC = sqrt(DC*TauC); 