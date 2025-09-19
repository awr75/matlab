function Eg_Si = Eg_Si(T)
% Bandgap in Si in Abhängigkeit von der Temperatur in eV
% Werte nach Sze (1981) Physics of Semiconductor Devices, p.15

Eg0 = 1.170;      % liefert EG bei 0 K
alpha = 4.73e-4;
beta = 636;

Eg_Si = Eg0 - alpha * T^2/(T+beta);