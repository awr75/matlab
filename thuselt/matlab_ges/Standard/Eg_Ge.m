function Eg_Ge = Eg_Ge(T)
% Bandgap in Ge in Abhängigkeit von der Temperatur in eV
% Werte nach Sze (1981) Physics of Semiconductor Devices, p.15

Eg0 = 0.7437;      % liefert EG bei 0 K
alpha = 4.774e-4;
beta = 235;

Eg_Ge = Eg0 - alpha * T^2/(T+beta);