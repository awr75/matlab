function Eg_GaAs = Eg_GaAs(T)
% Bandgap in GaAs in Abhängigkeit von der Temperatur in eV
% Werte nach Madelung (1981) Physics of Semiconductors - Basic Data

Eg0 = 1.519;      % liefert EG bei 0 K
alpha = 5.408e-4;
beta = 204;

Eg_GaAs = Eg0 - alpha * T^2/(T+beta);