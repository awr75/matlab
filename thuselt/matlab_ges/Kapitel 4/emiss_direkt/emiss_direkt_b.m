% emiss_direkt_b.m
% Spektralabh�ngigkeit der Emissionslinie in direkten Halbleitern
% mit kompletter Fermi-Verteilung (Boltzmann-Fall gestrichelt zum Vergleich)

clear;clf;
%****************************************
% Vorgabe der Substanz:
%****************************************
GaAs        % Aufruf Substanzparameter, evtl. �ndern
mred = 1/(1/me + 1/mh);  % reduzierte Masse

%****************************************
% Vorgabe der Teilchenkonzentrationen:
%****************************************
ne = input('  Ladungstr�gerkonzentration im Band = ');
nh = ne;

%****************************************
% Rechnung:
%****************************************
EFe = kT*rez_fermi(ne/Nc_0);  % Fermi-Energie der Elektronen
EFh = kT*rez_fermi(nh/Nv_0);  % Fermi-Energie der L�cher

dE = 0.01*kT;                 % Energieintervall
Emax = 8*kT + max(EFe,EFh);   % Endwert f�r die Berechnung
Erel = 0:dE:Emax;

iimax = length(Erel);
for ii=1:iimax
   Ee = (mred/me)*Erel(ii); Eh = (mred/mh)*Erel(ii);
   fe = 1/(1+exp((Ee-EFe)/kT));        % Verteilungsfunktion der Elektronen
   fh = 1/(1+exp((Eh-EFh)/kT));        % Verteilungsfunktion der L�cher
   fe_B = exp(-Ee/kT);                 % Verteilungsfunktion der Elektronen in Boltzmann-N�herung
   fh_B = exp(-Eh/kT);                 % Verteilungsfunktion der L�cher in Boltzmann-N�herung
   Isp(ii) = sqrt(Erel(ii)) * fe * fh;       % Intensit�t der spontanen direkten Emisssion
   Isp_B(ii) = sqrt(Erel(ii)) * fe_B * fh_B; % Intensit�t in Boltzmann-N�herung zum Vergleich
end
E_opt = Erel + EG;

%**************************
% Plot
%**************************
clf;
plot(E_opt,Isp/max(Isp), E_opt,Isp_B/max(Isp_B),'r:');
%plot(E_opt,Isp/max(Isp));            % f�r Boltzmann-Verteilungsfunktion

grid on;
title('Spontane Emission in GaAs');
xlabel('E_o_p_t/eV'); ylabel('Intensit�t/rel. Einheiten');
str1 = ['n_e = ',num2str(ne),' cm^-^3']; 
text(.96*E_opt(iimax), .6, str1); 