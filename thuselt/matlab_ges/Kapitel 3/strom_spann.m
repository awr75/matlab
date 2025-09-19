% Programm "strom_spann.m"
% Strom-Spannungs-Kennlinie einer Halbleiterdiode in Si
% (theoretisch)
%
clear
% ************************
% Konstanten und Parameter
% ************************
T = 300;       % Temperatur in Kelvin
silizium

A = 0.001;     % Fläche des pn-Übergangs in cm^-2

% **************************
% Wahl der Eingangsvariablen
% **************************

% Konzentrationen
ND = 1e14;     % Konzentration der Donatoren in cm-3
NA = 1e19;     % Konzentration der Akzeptoren in cm-3

% Minoritätsträgerdichten
n0 = ni_square_0/NA; p0 = ni_square_0/ND;
	% (ni_square_0 aus dem UP silizium.m)
% Lebensdauern
Taue = 1.0e-6; 
Tauh = 1.0e-6; 
% Beweglichkeiten und Diffusionskoeffizienten 
De = kT*mye(NA,T);       % Elektronen im p-Gebiet  
Dh = kT*myh(ND,T);       % Löcher im n-Gebiet 
% Diffusionslängen 
Le = sqrt(De*Taue); 
Lh = sqrt(Dh*Tauh); 

% ***************************
% Berechnung des Sättigungsstroms
% ***************************
Umax = 0.8;
U = -2:.001: Umax;      % Bereich der angelegten Spannung (in Volt)
js = (q*De/Le)*n0 + (q*Dh/Lh)*p0;   % in mA
Is =  A * js.*1e3;       % 1e3 wegen Umrechnung von js in mA

% *****************************
% Berechnung der Kennlinie j(U)
% *****************************
I = Is * (exp(U/kT) - 1);	% I entspricht Stromdichte j

% **************************
% Plot
% **************************
close
plot (U, I, '-'); grid on
axis([-.5 Umax -1e-2  2])
title ('Strom-Spannungs-Kennlinie einer Diode');
xlabel ('U / Volt')
ylabel ('I / mA')
