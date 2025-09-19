function plot_myges = plot_myges(nmax, substanz, T, donorflag, plotflag)
% Funktion plot_myges = plot_myges(nmax, substanz, T, donorflag, plotflag)
% Berechnung des störstellenbedingten Beitrags zur Gapshift 
% in Abhängigkeit von der Dotierung und der Temperatur
%
% Quelle: Thuselt, Rösler, phys.stat.sol. (b) 130, K139 (1985)
%
% - nmax ist die maximale Elektronenkonzentration
% - substanz ist das m-File des Halbleitermaterials, in Hochkomma eingeschlossen
%     (Default: 'Silizium')
% - T ist die abolute Temperatur (Default: 300 K)
% - Wenn donorflag = 1, dann Elektronen und Löcher vertauscht, also Akzeptordotierung
%     Dotierung mit Donatoren angenommen, dadurch Elektronendichte vorgegeben
%     Löcherdichte wird nach MWG berechnet
%     In allen anderen Fällen Donatordotierung angenommen (Default) 
%       donorflag kann für Donatordotierung auch weggelassen werden
% - Wenn plotflag = 1, dann Plot doppelt logarithmisch und numerische Ausgabe von Daten
%     Wenn plotflag = 2, dann Plot halblogarithmisch und numerische Ausgabe von Daten
%     Wenn plotflag = 0, werden keine Daten ausgegeben
% Das Programm ruft die Funktion myges(n, substanz, T, donorflag) auf und diese die
% folgenden Funktionen:
%		f_myxce(n, substanz, T, donorflag);   
%		f_myxch(n, substanz, T, donorflag);   
%		f_myie(n, substanz, T, donorflag);   
%		f_myih(n, substanz, T, donorflag);

% Wenn Akzeptordotierung vorgegeben (p-Material, d.h. donatorflag = 1),
%       dann wird vertauscht
%       Ryde <-> Rydh
%       abe <-> abh

%*********************************************************
% Allgemeines
if nargin < 5, plotflag = 1; end
if nargin < 4, donorflag = 0; end
if nargin < 3, T = 300; end
if nargin < 2, substanz = 'Silizium'; end
if nargin < 1, nmax = 1e21; end
if strcmpi(substanz,'Si'); substanz = 'Silizium'; end
if strcmpi(substanz,'Ge'); substanz = 'Germanium'; end

% *************************************************
% Festlegung des Wertebereichs und der Stützstellen
% *************************************************
nmin = 1e12;     % Untergrenze der Elektronenkonzentration
logn = log10(nmin):.1:log10(nmax);
interv = 10;                % Zahl der Stützstellen pro Zehnerpotenz
midpoints = log10(nmax/nmin)*interv + 1;
logn = linspace(log10(nmin),log10(nmax),midpoints);

% *******************************
% Berechnung der chem. Potentiale
% *******************************
iimax = length(logn);
for ii = 1:iimax
   n(ii) = 10^(logn(ii));
end
   n = 10.^(logn);
my_ges = myges(n, substanz, T, donorflag);

% **************************
% Plot
% **************************
if plotflag == 1	% doppelt log. Ausdruck
	loglog (n,my_ges, 'k');grid on; 			     % Gesamtlösung
   axis ([n(1) n(max(ii)) -1e3 -1e-3]);
   xlabel('lg(n/cm^-^3)'); ylabel('E/meV');
   title ('Gapabsenkung durch Austausch-Korrelation und Störstellen');
   if donorflag == 1     % bei Akzeptordotierung
      text_string = ['p-', substanz,', ',num2str(T),' K'];
	else                  % bei Donatordotierung
      text_string = ['n-', substanz,',  ',num2str(T),' K'];
	end
	text(nmin,max(my_ges),text_string); 

elseif plotflag == 2            % einfach log. Ausdruck
   plot (logn,my_ges, 'k'); grid on; 				
   axis ([logn(1) logn(max(ii)) my_ges(max(ii)) -1e-2]);
   xlabel('lg(n/cm^-^3)'); ylabel('E/meV');
   title ('Gapabsenkung durch Austausch-Korrelation und Störstellen');
   if donorflag == 1     % bei Akzeptordotierung
      text_string = ['p-', substanz,', ',num2str(T),' K'];
	else                  % bei Donatordotierung
      text_string = ['n-', substanz,',  ',num2str(T),' K'];
	end
   text(min(logn),max(my_ges)-7,text_string); 
else
end

%**********************************************
% Ausgabe von Zahlenwerten
%**********************************************
% (nur wenn plotflag gesetzt ist)
if plotflag == 1 | plotflag == 2
	if donorflag == 1     % bei Akzeptordotierung
   	disp(' '); disp ('Akzeptordotierung');
   	string1 = sprintf('   p       myges');     
	else                  % bei Donatordotierung
   	disp(' '); disp ('Donatordotierung');
   	string1 = sprintf('   n       myges');     
	end
	disp(string1);
	string1 = sprintf('   cm^-3     meV      ');     
	disp(string1);
	string1 = sprintf('---------------------------');     
	disp(string1);

	for ii = 1:interv:midpoints   % nur jeden 100. Wert anzeigen
      string2 = sprintf('%2.2e     %2.4f',...
         n(ii), my_ges(ii));     
		disp(string2);
   end
end
disp(' ');
