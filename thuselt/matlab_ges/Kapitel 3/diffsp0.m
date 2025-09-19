% Programm "diffsp0.m"
% Diffusionsspannung in Silizium 
% an einem (p+/n)- bzw. (p/n+)-Übergang bei 300 K
% aufgetragen über der Dotierungskonzentration Ndot
% des schwächer dotierten Gebiets

clf
clear

% *******************************************
% Wahl des Dotierungsbereichs (1e14 bis 1e19)
% *******************************************
Ndot = logspace(14,19);

% *******************************************
% Wahl der Substanz und Berechnung von UD
% *******************************************
Silizium;
   % silizium macht alle Parameter des M-Files "silizium.m" verfügbar
   % Wahl einer anderen Substanz durch Aufruf der entsprechenden Datei 
UD = 2*kT.*log(Ndot./ni_0);   
   % Berechnung der Diffusionsspannung für jeweilige Substanz

% *******************************************
% Plot, Achsenbeschriftungen usw. 
% *******************************************
semilogx (Ndot,UD,'-'); 
axis ([1.0e14  1.0e19  0  2.3]);
xlabel ('N_A or N_D (cm^-^3)')
ylabel ('U_D (Volt)')
title ('Diffusionsspannung')

% Beschriftung der einzelnen Kurven (Substanzdaten):    
set (gca,'DefaultTextUnits','normalized')
s1 = sprintf('Silizium, n_i = %1.4g cm^-^3', ni_0);  
text (.20,UD(5)/2.3,s1);


