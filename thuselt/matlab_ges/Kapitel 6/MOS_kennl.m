% Programm MOS_kennl.m
% Kennlinienfeld eines MOS-Kondensators
% *********************************************
% verwendet die Funktion phi_inv.m

close
clear
UDS_max = 9;       % max. Wert der Drainspannung

j = input(' Zahl der Kurven pro Kennlinienfeld... (Default: 6) ');
if isempty(j), j = 6; end   
U_fb = input(' Flachbandspannung in Volt... (Default: 0 V) ');
if isempty(U_fb), U_fb = 0; end   

UG_max = (j-1);   % Gate-Spannungsdifferenzen ganzzahlig

silizium          % Substanz - bei Bedarf ändern
NA = 1e16;
c_Iso = 5e-6;
ph = phi_inv(NA, ni_0, kT);
   
% ********************************************
% Berechnung und Plot der Kennlinen
% ********************************************
lowlim = fix(U_fb);
for i = lowlim:(lowlim+j),
   UG = (i-1);
   if UG>=U_fb
  
      UDS = linspace(0,UG-U_fb);
      bmax = sqrt(4*eps0*epsrel*(ph+UDS)/(100*q*NA));
   	  % eps0 in As V^-1 m^-1, daher Faktor 100 zur Umrechnung in cm
   
      % **********************************************************
      % Berechnung der Kennlinien in quadratischer Näherung
      % **********************************************************
      UDS = linspace(0,UG-U_fb);
      I1 = (UG-U_fb)*UDS-UDS.*UDS./2; % quadratische Näherung
      Is = .5*(UG-U_fb).^2;           % Sättigungsstrom
      I = [I1,Is];
      UDS = [UDS,UDS_max];
      
      % -----------------------
      % Plot der Kennlinien
      % -----------------------
      if i==j   % Achsenbezeichnungen usw., wenn maximaler UG-Wert
         plot(UDS,I, 'r'); 
      else
         plot(UDS,I,'r');
      end
      % Text an Plot der quadrat. Näherung:
      str1 = ['U_G = ', num2str(UG),' V'];
      a = text(UDS_max-2,Is+0.2,str1);       % a ist ein Text-handle
      set(a,'color','r')                     % färbt den Text rot ein

      
      % **********************************************************
      % Berechnung der Kennlinien in gradual channel Approximation
      % **********************************************************
      UDS = linspace(0,UDS_max);
      I1_mod_1 = (UG - U_fb - ph - UDS/2).*UDS;  
      a1 = (2/3)*sqrt(2*eps0*epsrel*q*NA/100)/c_Iso;
         % 100 im Nenner zur Umrechnung m -> cm bei eps0
      a2 = (UDS+ph).^1.5 - ph^1.5;
      I1_mod_2 = a1 * a2;
      I1_mod_2 = 0;
      I1_mod = I1_mod_1 - I1_mod_2;  
         % modifizierter Strom mit Berücksichtigung des Verarmungsanteils
   
      [Is_max,ii_max] = max(I1_mod);   % Sättigungsstrom, bleibt konstant
      for ii = 1:length(I1_mod)
         if ii > ii_max
            I1_mod(ii) = Is_max;
         end
      end
      UDS = [UDS,UDS_max];
      bmax_max = sqrt(4*eps0*epsrel * (ph+UDS_max)/(100*q*NA));
   	  % eps0 in As V^-1 m^-1, daher Faktor 100 zur Umrechnung in cm
      bmax = [bmax,bmax_max];
      I_mod = [I1_mod, Is_max];  

      % -----------------------
      % Plot der Kennlinien
      % -----------------------
      if i==j   % Achsenbezeichnungen usw., wenn maximaler UG-Wert
         plot(UDS,I_mod, 'b');
         UG_max = UG;         % Maximalwert der Gatespannung merken
      else
         plot(UDS,I_mod,'b');
      end
      % Text an Plot der gradual channel Approximation
      str1 = ['U_G = ', num2str(UG),' V'];
      a = text(UDS_max-2,Is_max+0.2,str1);   % a ist ein Text-handle
      set(a,'color','b')                     % färbt den Text blau ein
      hold on;
   end
end

% ********************************************
% Berechnung und Plot der Sättigungsstromkurve 
% für quadratische Näherung
% ********************************************
UG = linspace(U_fb,UG_max+.2);
UDS = UG -U_fb;
Is = .5*(UG-U_fb).^2;           % Sättigungsstrom
plot(UDS.*(UG>=U_fb),Is.*(UG>=U_fb),'--r');

% ********************************************
% Formatierung des Bildes
% ********************************************
axis([0 UDS_max 0 1.1*max([I,I_mod])]);
xlabel('U_D_S (Volt)');  ylabel('I/(/uC_0w/L) (Volt^2)');
      str2 = ['I(U_D_S)-Kennlinie eines MOSFET mit U_f_b = ', num2str(U_fb),' V'];
title(str2); 
legend('blau: grad. channel', 'rot: quadratische Näherung',2);
grid on;
hold off;
