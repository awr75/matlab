function Eg_InAs = Eg_InAs(T)
% Bandgap in InAs in Abhängigkeit von der Temperatur in eV
% Werte nach Madelung (1981) Physics of Semiconductors - Basic Data

Eg0 = 0.418;      % liefert EG bei 0 K
alpha = 0.58e-3;
beta = 500;

Eg_InAs = Eg0 - alpha * T^2/(T+beta);