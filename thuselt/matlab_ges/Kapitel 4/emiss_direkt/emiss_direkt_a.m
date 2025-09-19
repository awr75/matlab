% Programm emiss_direkt_a.m
% Spektralabh�ngigkeit der Emissionslinie in direkten Halbleitern
% Boltzmann-N�herung f�r Verteilungsfunktionen

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
EFh = kT.*log(nh/Nv_0);  % Fermi-Energie der L�cher

dE = 0.01*kT;                 % Energieintervall
Emax = 8*kT + max(EFe,EFh);   % Endwert f�r die Berechnung
Erel = 0:dE:Emax;

iimax = length(Erel);
for ii=1:iimax
   Ee = (mred/me)*Erel(ii); Eh = (mred/mh)*Erel(ii);
   fe = 1/(1+exp((Ee-EFe)/kT));  % Verteilungsfunktion der Elektronen
   fh = 1/(1+exp((Eh-EFh)/kT));  % Verteilungsfunktion der L�cher
   fe_B = exp(-Ee/kT);           % Verteilungsfunktion der Elektronen in Boltzmann-N�herung
   fh_B = exp(-Eh/kT);           % Verteilungsfunktion der L�cher in Boltzmann-N�herung
   Isp(ii) = sqrt(Erel(ii)) * fe_B * fh_B; % Intensit�t in Boltzmann-N�herung
end
E_opt = Erel + EG;

%****************************************
% Plot:
%****************************************
plot(E_opt,Isp/max(Isp));
grid on;
title('Spontane Emission in GaAs. ');
xlabel('E_o_p_t/eV'); ylabel('Intensit�t/rel. Einheiten');
str1 = ['n_e = ',num2str(ne),' cm^-^3']; 
text(.96*E_opt(iimax), .6, str1); 