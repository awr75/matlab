function me_Si = me_Si(T)
% Effektive Masse in Si in Abhängigkeit von der Temperatur
% in Einheiten von m0
% Werte nach Pierret (1996) Semiconductor Device Fundamentals, p.55
% angepasst an verwendeten Wert von me
% Bereich 200 K bis 700 K

me0 = 0.1645; 
a = 6.11e-4;
b = 3.09e-7;

me_Si = me0 + a*T - b*T^2;