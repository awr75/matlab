% Programm GaN.m
%*******************************************************
% m-File zur Eingabe der Materialparameter von GaN
%
% EG          Bandabstand bei 300 K in eV
% epsrel      relative DK
% me          effektive Masse des Leitungsbandes
% mh          effektive Masse des Valenzbandes
% nue_e    	  Zahl der Täler des Leitungsbandes
% ED          Bindungsenergie des Donators in eV
% aBe         Störstellenradius des Donators in m
% EA          Bindungsenergie des Akzeptors in eV
% aBh         Störstellenradius des Akzeptors in m
% Nc_0        eff. Zustandsdichte des Leitungsbands bei 300 K in cm-3
% Nv_0        eff. Zustandsdichte des Valenzbands bei 300 K in cm-3
% ni_0        intrinsische Ladungsträgerkonzentration bei 300 K in cm-3
% mye_i       Elektronenbeweglichkeit im eigenleitenden Material bei 300 K in cm^2/(Vs)
% myh_i       Löcherbeweglichkeit im eigenleitenden Material bei 300 K in cm^2/(Vs)

konstanten;             % Aufruf physikalischer Grunddaten

EG = 3.39;					% Bandabstand bei 300 K in eV
epsrel = 8.9;				% relative DK
me = 0.20;					% effektive Masse des Leitungsbandes
mh = 0.85;					% effektive Masse des Valenzbandes
nue_e = 1;					% Zahl der Täler des Leitungsbandes
mye_i = 1000;           % Elektronenbeweglichkeit im eigenleitenden Material bei 300 K
myh_i = 30;             % Löcherbeweglichkeit im eigenleitenden Material bei 300 K
   % Nakamura et al. (2000) The Blue Laser Diode. Springer, Berlin

ED = EH * me/epsrel^2;  % Bindungsenergie des Donators in eV
aBe = aB0 * epsrel/me;  % Störstellenradius des Donators in m
EA = EH * mh/epsrel^2;  % Bindungsenergie des Akzeptors in eV
aBh = aB0 * epsrel/mh;  % Störstellenradius des Akzeptors in m

% Berechnung für 300 K
Nc_0 = 2 * nue_e * me^1.5 * 1.254708e19;  % eff. Zustandsdichte des Leitungsbands in cm-3
Nv_0 = 2 * mh^1.5 * 1.254708e19;          % eff. Zustandsdichte des Valenzbands in cm-3
ni_square_0 = Nc_0 * Nv_0 * exp(-EG/kT); 
ni_0 = sqrt(ni_square_0);                  % intrinsische Ladungsträgerkonzentration in cm-3


