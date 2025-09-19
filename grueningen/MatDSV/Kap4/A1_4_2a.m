% M-File  A1_4_2a.m      
% Lösung zu Kap.4, Aufgabe 2(a)
%
% Energieberechnung


% Berechnung des Signalvektors
x=[0:0.025:0.225 0.25 0.225:-0.025: 0.025]' 

% Berechnung der Energie
E=x'*x, c=40e-6; W=c*E
Wwahr=2/3*100*25e-6*1e-2
Fehler_in_Prozent =(W-Wwahr)/Wwahr*100
