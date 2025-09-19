function Eg_GaP = Eg_GaP(T)
% Bandgap in Si in Abhängigkeit von der Temperatur in eV
% Werte nach Madelung (1981) Physics of Semiconductors - Basic Data

Eg0 = 2.338;      % liefert EG bei 0 K
alpha = 6.2e-4;
beta = 460;

Eg_GaP = Eg0 - alpha * T^2/(T+beta);