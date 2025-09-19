function linie = linie(R1,R2,m,col_1)
% Funkton linie.m
% Programm für Linie im Raum
% Endpunkte sind R1 = (x1,y1,z1) und R2 = (x2,y2,z2)
% m ist die Strichstärke
% col_1 ist die Linienfarbe

X = [R1(1), R2(1)];
Y = [R1(2), R2(2)];
Z = [R1(3), R2(3)];
plot3(X,Y,Z,col_1,'LineWidth',m)