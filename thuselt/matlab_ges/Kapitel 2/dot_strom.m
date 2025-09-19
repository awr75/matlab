% Programm dot_strom.m
% zu Aufgabe 2.15:
% Ermittlung der Dotierungskonzentration aus Strommessungen

konstanten;
I = 0.0011   % Strom in Ampere
len = 1;     % L�nge in cm
A = 0.005;   % Fl�che in cm^-2
U = 1;       % Spannung in Volt
sigma = I*len/(A*U) % Leitf�higkeit
mye_n = sigma/q  % linke Seite: Produkt aus Beweglichkeit und Konzentration
n = fzero('x*mye(300,x)-1.3733e+018',1e17)
