function Eg_InSb = Eg_InSb(T)
% Bandgap in InSb in Abhängigkeit von der Temperatur in eV
% Werte nach Madelung (1981) Physics of Semiconductors - Basic Data

Eg0 = 0.2352;      % liefert EG bei 0 K
alpha = 0.6e-3;
beta = 500;

Eg_InSb = Eg0 - alpha * T^2/(T+beta);