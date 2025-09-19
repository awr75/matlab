function varargout = f_myxce (n, substanz, T, donorflag)
% Funktion varargout = f_myxce(n, substanz, T, donorflag)
% Berechnung des xc-Leitungsbandbeitrags zur Gapshift in Abhängigkeit von der Dotierung
% und der Temperatur
%
% Quelle: Thuselt, Rösler, phys.stat.sol. (b) 130, K139 (1985)
%
% - n ist die Elektronenkonzentration
% - substanz ist das m-File des Halbleitermaterials, in Hochkomma eingeschlossen
%     (Default: 'Silizium')
% - Wenn donorflag = 1, dann Elektronen und Löcher vertauscht, also Akzeptordotierung
%     Dotierung mit Donatoren angenommen, dadurch Elektronendichte vorgegeben
%     Löcherdichte wird nach MWG berechnet
%     In allen anderen Fällen Donatordotierung angenommen (Default) 
%       donorflag kann für Donatordotierung auch weggelassen werden
% - T ist die abolute Temperatur (Default: 300 K)
%
% Wenn Akzeptordotierung vorgegeben (p-Material) (donatorflag = 1),
%       dann wird vertauscht
%       Ryde <-> Rydh
%       abe <-> abh

%*********************************************************

% Allgemeines
if nargin < 4, donorflag = 0; end
if nargin < 3, T = 300; end
if nargin < 2, substanz = 'Silizium'; end
if strcmpi(substanz,'Si'); substanz = 'Silizium'; end
if strcmpi(substanz,'Ge'); substanz = 'Germanium'; end

n = n(:)';
%***********************************************
% Aufruf Halbleitermaterial -> Substanzparameter
%***********************************************
eval(substanz);
% Hieraus resultieren:
% Nc_0 = eff. Zustandsdichte im LB
% Nv_0 = eff. Zustandsdichte im VB
% me = eff. Masse der Majoritätsträger (Elektronen)
% mh = eff. der Minoritätsträger (Löcher)
% nue_e = Tälerzahl (im Valenzband =1)

if donorflag == 1
   % Bohrradien und Rydberg bei Akzeptordotierung:
	Ryde = EA*1e3;             	% Elektronen-Rydberg in meV
	Rydh = ED*1e3;             	% Löcher-Rydberg in meV
	abe = aBh*1e2;                % Bohrradius des Elektrons in cm
	abh = aBe*1e2;                % Bohrradius des Lochs in cm
   Nc0 = Nv_0;                   % eff. Zustandsdichte im LB
   Nv0 = Nc_0;                   % eff. Zustandsdichte im VB
   nuee = 1;							% keine Vieltalstruktur im Valenzband
else
	% Bohrradien und Rydberg bei Donatordotierung:
	Ryde = ED*1e3;             	% Elektronen-Rydberg in meV
	Rydh = EA*1e3;             	% Löcher-Rydberg in meV
	abe = aBe*1e2;                % Bohrradius des Elektrons in cm
	abh = aBh*1e2;                % Bohrradius des Lochs in cm
   Nc0 = Nc_0;                   % eff. Zustandsdichte im LB
   Nv0 = Nv_0;                   % eff. Zustandsdichte im VB
   nuee = nue_e;
end

% Weitere Abkürzungen:
ninorm2 = exp(-EG/kT);  
   		      % ni normiert: ninorm = ni/sqrt(Nc_0*Nv_0)
kT1 = kB*T*1000;	% von hier ab kT in meV benötigt

%*********************************************************
% Bereichsgrenzen
%*********************************************************
% Bereichsgrenzen für xce

kTT_e = 1.85 * nuee^2 * Ryde; % Intersection line kTT_e (hohe/niedrige Temperaturen)
QT1 = 1 / (kT1/kTT_e+1); QT2 = 1 / (kTT_e/kT1+1); % Vorfaktoren mit kTT_e berechnen

% *******************************
% Berechnung der chem. Potentiale
% *******************************

% Grenzen zwischen den Bereichen
   n0_tilde = 0.023 * nuee^4;
   % (Grenze zwischen TF screening und Debye-Screening bei hohen Konzentrationen)
	n1_tilde = 0.0067 * (kT1/Ryde)^2;
   % (Grenze zwischen Debye screening und sw screening)
   n2_tilde = (0.0037/nuee^2) * (kT1/Ryde)^3;
   % (Grenze zwischen Debye screening und TF screening)

% fitting coefficients
	alpha_0_e=.57; alpha_0str_e=.57; gamma_0_e=1/3;
	alpha_1_e=1.63; alpha_1str_e=1.63; gamma_1_e=1;
	alpha_2_e=1; alpha_2str_e=1;
   
   ne_tld = n .* abe^3;
   
% Energien für die einzelnen Näherungen
   myxc_e_D = -5.01 * sqrt(Ryde/kT1) * sqrt(ne_tld) * Ryde; % Debye screening
   myxc_e_sw = -1.44 * ne_tld.^.25 .* Ryde;                 % short wave screening
   myxc_e_TF = -1.97/nuee^(1/3) .* ne_tld.^(1/3) * Ryde;   % Thomas-Fermi screening

 
% Übergangsbereiche
   Q0 = (ne_tld./n0_tilde).^gamma_0_e;
   Q1 = (ne_tld./n1_tilde).^gamma_1_e; Q2 = ne_tld./n2_tilde;
   K01 = 1./(alpha_0_e.*Q0 + 1); K02 = 1./(alpha_0str_e./Q0 + 1);
   K11 = 1./(alpha_1_e.*Q1 + 1); K12 = 1./(alpha_1str_e./Q1 + 1);
   K21 = 1./(alpha_2_e.*Q2 + 1); K22 = 1./(alpha_2str_e./Q2 + 1);
   
% Approximationen
   myxc_e_0 = myxc_e_sw.*K01 + myxc_e_TF.*K02; 
   myxc_e_low = myxc_e_D.*K11 + myxc_e_0.*K12;
   myxc_e_high = myxc_e_D.*K21 + myxc_e_TF.*K22;
   myxc_e_appr = myxc_e_low.*QT1 + myxc_e_high.*QT2;
   
% *******************************
% Ergebnisse
% *******************************
varargout {4} = myxc_e_TF;
varargout {3} = myxc_e_sw;
varargout {2} = myxc_e_D;
varargout {1} = myxc_e_appr;