% Programm "leerlaufsp.m"
% Leerlaufspannung in Abhängigkeit vom Photostrom in Si
% (theoretisch)
%
clear
close
% ************************
% Konstanten und Parameter
% ************************
kT = 0.02585;        % Energie entsprechend 300 K in eV 
						 	% (oder "Temperaturspannung" entsprechend 300 K in Millivolt)

% **************************
% Wahl der Eingangsvariablen
% **************************
A = 0.001;                     % Fläche des pn-Übergangs in cm^-2
UD = 0.85;                     % Diffusionsspannung
U = 0:.01: UD;                 % Bereich der angelegten Spannung (in Volt)
js = 2.49e-8;                  % Sättigungsstrom
Is =  A * js;       
Iopt_max = -Is * exp(UD/kT);   % maximaler Photostrom, begrenzt durch Diffusionsspannung

% ***********************************************************************
% Berechnung der Leerlaufspannung in Abhängigkeit vom Photostrom UL(Iopt)
% ***********************************************************************

Schrittzahl = 1000;
Iopt(1) = 0;                             % Startwert
dIopt = Iopt_max/Schrittzahl;            % Zuwachs
for ii = 2:(Schrittzahl+2); 
   Iopt(ii) = Iopt(ii-1) + dIopt;        % Photostrom
   UL(ii) = kT * log(1+Iopt(ii)/(-Is));  % Leerlaufspannung
   ii = ii+1;
end

% **************************
% Plot
% **************************
plot(-Iopt,UL); axis([0 -Iopt_max 0 UD]);
grid; xlabel('I_p_h(mA)'); ylabel('U_L(V)'); 
str1 = ['Sperrstrom I_s = ',num2str(Is),' mA']; 
text(0.26*(-Iopt_max),0.32*UD, str1); 
title('Leerlaufspannung einer Photodiode'); 


