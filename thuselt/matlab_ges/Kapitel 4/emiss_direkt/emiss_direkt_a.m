% Programm emiss_direkt_a.m
% Spektralabhängigkeit der Emissionslinie in direkten Halbleitern
% Boltzmann-Näherung für Verteilungsfunktionen

clear;
clf;
%****************************************
% Vorgabe der Substanz:
%****************************************
GaAs        % Aufruf Substanzparameter
mred = 1/(1/me + 1/mh);  % reduzierte Masse

%****************************************
% Vorgabe der Teilchenkonzentrationen:
%****************************************
ne = 1e17;
nh = ne;

%****************************************
% Rechnung:
%****************************************
EFe = kT.*log(ne/Nc_0);  % Fermi-Energie der Elektronen
EFh = kT.*log(nh/Nv_0);  % Fermi-Energie der Löcher

dE = 0.01*kT;                 % Energieintervall
Emax = 8*kT + max(EFe,EFh);   % Endwert für die Berechnung
Erel = 0:dE:Emax;

iimax = length(Erel);
for ii=1:iimax
   Ee = (mred/me)*Erel(ii); Eh = (mred/mh)*Erel(ii);
   fe = 1/(1+exp((Ee-EFe)/kT));  % Verteilungsfunktion der Elektronen
   fh = 1/(1+exp((Eh-EFh)/kT));  % Verteilungsfunktion der Löcher
   fe_B = exp(-Ee/kT);           % Verteilungsfunktion der Elektronen in Boltzmann-Näherung
   fh_B = exp(-Eh/kT);           % Verteilungsfunktion der Löcher in Boltzmann-Näherung
   Isp(ii) = sqrt(Erel(ii)) * fe_B * fh_B; % Intensität in Boltzmann-Näherung
end
E_opt = Erel + EG;

%****************************************
% Plot:
%****************************************
plot(E_opt,Isp/max(Isp));
grid on;
title('Spontane Emission in GaAs. ');
xlabel('E_o_p_t/eV'); ylabel('Intensität/rel. Einheiten');
str1 = ['n_e = ',num2str(ne),' cm^-^3']; 
text(.96*E_opt(iimax), .6, str1); 