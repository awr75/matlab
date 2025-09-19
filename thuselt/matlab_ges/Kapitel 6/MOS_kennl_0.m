% Programm MOS_kennl_0.m
% Kennlinienfeld eines MOS-Kondensators
% *********************************************

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
   
% ********************************************
% Berechnung und Plot der Kennlinen
% ********************************************
lowlim = fix(U_fb);
for i = lowlim:(lowlim+j),
   UG = (i-1);
   if UG>=U_fb
  
      UDS = linspace(0,UG-U_fb);
   
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
axis([0 UDS_max 0 1.1*max(I)]);
xlabel('U_D_S (Volt)');  ylabel('I/(/uC_0w/L) (Volt^2)');
      str2 = ['I(U_D_S)-Kennlinie eines MOSFET mit U_f_b = ', num2str(U_fb),' V'];
title(str2); 
grid on;
hold off;
