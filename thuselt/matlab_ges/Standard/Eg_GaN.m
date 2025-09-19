function Eg_GaN = Eg_GaN(T)
% Bandgap in GaN in Abhängigkeit von der Temperatur in eV
% Werte nach Madelung (1981) Physics of Semiconductors - Basic Data

Eg0 = 3.503;      % liefert EG bei 0 K
alpha = 5.08e-4;
beta = 996;

Eg_GaN = Eg0 - alpha * T^2/(beta-T);