% Programm npn_basis.m
% Berechnung der Kennlinien eines npn-Transistors in Basisschaltung
% einschlie�lich Early-Effekt und Sto�ionisation

disp(' ');
disp(' Berechnung der Kennlinien eines npn-Transistors in Basisschaltung');
disp(' einschlie�lich Early-Effekt und Sto�ionisation');
% (nach Pierret)
% Zur Bearbeitung wird das Unterprogramm npn0.m ben�tigt.
% UP npn0.m ruft seinerseits die Unterprogramme mye.m und myh.m 
        % sowie das UP Silizium.m f�r die Substanzdaten auf.
% F�r die Ber�cksichtigung der Basisweitenver�nderung durch den Early-Effekt
        % wird zus�tzlich das Unterprogramm npn_early.m aufgerufen. 

clear
npn0 
% Im Unterprogramm npn0.m werden Konstanten, Materialparameter und Bauelementedaten 
        % festgelegt.

% ********************************************
% Berechnung der Ebers-Moll-Parameter (W = WB) 
% ********************************************
disp(' ');
disp(' Allgemeine L�sung (1) oder N�herung schmaler Basis? (2)...(Default: allgemein) :');
sb = input('   Bitte w�hlen... ');
if isempty(sb), sb = 1; end   

W = WB; 
a = W/LB;
rEB = DE*pE0*LB/(DB*nB0*LE);
rCB = DC*pC0*LB/(DB*nB0*LC);
if sb ==1
   % allgemeine L�sung
   fB = (DB/LB)*nB0*coth(a); 
   IES = q*A*((DE/LE)*pE0 + fB);    % Sperrstrom des Emitter-Basis-�bergangs bei UCB=0
   ICS = q*A*((DC/LC)*pC0 + fB);    % Sperrstrom des Kollektor-Basis-�bergangs bei UEB=0
   aV = 1 /(cosh(a)+rEB*sinh(a)); 
   aR = 1 /(cosh(a)+rCB*sinh(a)); 
else
   % N�herung schmaler Basis
   W = WB; 
   fB = (DB/W)*nB0;
   IES = q*A*((DE/LE)*pE0 + fB);    % Sperrstrom des Emitter-Basis-�bergangs bei UCB=0
   ICS = q*A*((DC/LC)*pC0 + fB);    % Sperrstrom des Kollektor-Basis-�bergangs bei UEB=0
   aV = 1 /(1+a*rEB);
   aR = 1 /(1+a*rCB);
end

% **********************************
% Bereichsgrenzen f�r die Spannungen
% **********************************
UbiE = kT*log(NE*NB/ni_0^2); % Diffusionsspannung des Emitter-Basis-�bergangs
UbiC = kT*log(NC*NB/ni_0^2); % Diffusionsspannung des Kollektor-Basis-�bergangs
                             % (wird nur beim Early-Effekt ben�tigt)

UCB_min = 1;      % Minimalwert f�r die Berechnung von UCB in Volt
UCB_max = 2;   	% Maximalwert
UCE_min = 1;      % Minimalwert f�r die Berechnung von UCE in Volt
UCE_max = 100; 	% Maximalwert
% Zur Ver�nderung der Material- und Bauelementeparameter
        % m�ssen die Daten in npn0 variiert werden.
close

UCB_max = 60*(NC/1.0e16).^(-3/4); 
m = 6; 
UCE_max = UCB_max*(1-aV).^(1/m);

% ***************************************
% Abfrage nach gew�nschtem Kennlinienfeld
% ***************************************
disp('');
disp(' Gew�nschtes Kennlinienfeld:');
disp('   Eingangskennlinien der Basisschaltung (1),');
disp('   Ausgangskennlinien der Basisschaltung (2),'); 
c = input('   Bitte w�hlen... (Default:1)');
if isempty(c), c = 1; end   

j = input(' Zahl der Kurven pro Kennlinienfeld... (Default:6) ');
if isempty(j), j = 6; end   

if c == 1, 
   bw = input(' mit Basisweitenmodulation? 1-Ja, 2-Nein...(Default: Ja) '); 
   if isempty(bw), bw = 1; end   
end 

% *******************************************
% Rechnung
% *******************************************
for i = 1:j, 
   switch c
   % ***********************************************
   % Fall (1): Eingangskennlinien der Basisschaltung
   % ***********************************************
   case 1
		UCB = -(i-1)*10; 
   	UEB = 0:0.005:UbiE; 
   	jj = length(UEB); 
   	if bw == 1, 
   		npnmod 			% UP Basisweitenmodulation 
		end 
		IE = (-IES.*(exp(UEB/kT)-1) + aR.*ICS.*(exp(UCB/kT)-1)) * 1.0e3; 
		% 1.0e3 zur Umrechnung A in mA 
		if i == j, 
     		plot(UEB,-IE); axis ([0 UbiE 0 5]); 
     		grid; xlabel('U_E_B(V)'); ylabel('-I_E(mA)');
         title('Eingangskennlinien in Basisschaltung'); 
		else 
     		plot(UEB,-IE);
		end 

   % ***********************************************
   % Fall (2): Ausgangskennlinien der Basisschaltung
   % ***********************************************
   case 2
   	IE_ = (i-1) * 1.0e-3;   % negativer Emitterstrom IE_ = -IE
   	UCB1 = UCB_min:-0.01:0; 
   	UCB2 = 0:-UCB_max/200:-UCB_max; 
	   UCB = [UCB1,UCB2]; 
   	jj = length(UCB); 
   	IC = (aV*IE_-(1-aV*aR)*ICS*(exp(UCB/kT)-1))*(1.0e3); 
   	if i == j, 
     		plot(-UCB,IC); axis([-UCB_min UCB_max 0 1.3e3*IE_]);
			grid; xlabel('-U_C_B(V)'); ylabel('I_C(mA)'); 
     		text(0.27*UCB_max,1.1e3*IE_,'-I_E / Schrittweite = 1mA'); 
		   title('Ausgangskennlinien in Basisschaltung'); 
      else 
     		plot(-UCB,IC); 
   	end 
   
	end 
hold on
end 
hold off 