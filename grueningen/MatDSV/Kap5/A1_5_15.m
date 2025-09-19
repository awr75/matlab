% M-File  A1_5_15.M      
% Lösung zu Band 1, Kap.5, Aufgabe 15 
% 
% Zwei gleichfrequente, phasenverschobene Sinusschwingungen,
% die mit normalverteiltem weissen Rauschen gestört sind,
% werden in symmetrische Rechteckschwingungen umgewandelt.
% Ihre Kreuzkorrelationsfunktion wird geschätzt.
% Aus dem Wert der Kreuzkorrelationsfunktion an der Stelle m=0
% wird die Phasenverschiebung berechnet.


% Eingaben
phi=30; f0=1; fs=1000; N=2000; SNR=40;

J=1;
while J==1
    
 % Parameterwerte auf Bildschirm darstellen
 close,disp(' '),disp('Parameter:'),disp(' ')
 disp(['1.  ','Phase der zweiten Sinusschwingung  phi =  ',num2str(phi),   ' Grad']) 
 disp(['2.  ','Frequenz der Sinusschwingungen     f0  =  ',num2str(f0),    ' Hz  '])
 disp(['3.  ','Abtastfrequenz                     fs  =  ',num2str(fs),    ' Hz  '])
 disp(['4.  ','Anzahl Abtastwerte                 N   =  ',num2str(N), '         '])
 disp(['5.  ','Signal to Noise Ratio              SNR =  ',num2str(SNR),   ' dB  '])
 disp(' ')
 disp(' '), disp('Geben Sie Ihre neuen Parameter ein und schliessen Sie mit der Tastenfolge R E T U R N ab')
 disp(' '), keyboard

 
if f0>0.5*fs
    error('Die Frequenz f0 ist zu gross')
end
if N<fs/f0
    error('Die Anzahl Abtastwerte ist zu klein')
end

 
% Rechteckschwingungen generieren
T=1/fs; n=0:N-1; t=n*T; sigma=sqrt(0.5*10^(-SNR/10));
x=sin(2*pi*f0*n*T)+sigma*randn(1,N); y=sin(2*pi*f0*n*T+phi/180*pi)+sigma*randn(1,N);
subplot(3,2,1),plot(t,x),grid,title('Sinusschwingung 1')
subplot(3,2,3),plot(t,y),grid,title('Sinusschwingung 2')
x=2*(x>0)-1; y=2*(y>0)-1;
subplot(3,2,2),plot(t,x),grid,title('Rechteckschwingung 1')
subplot(3,2,4),plot(t,y),grid,title('Rechteckschwingung 2')

% Autokorrelationsfunktion schätzen
m=-N+1:N-1; tau=m*T;
rdachxy=xcorr(y,x,'unbiased'); 
subplot(3,2,6),plot(tau,rdachxy),grid, 
title('Schätzung rdachxy[m] der Kreuzkorrelationsfunktion')

set(gcf,'Units','normal','Position',[0.45 0.05 0.5 0.5])

% Phase berechnen
disp(' '),disp(' '),disp(' ')
rdachxy0=rdachxy(N); 
    if rdachxy(N+1)-rdachxy(N-1)>0 
    phidach=90*(rdachxy0-1);
    else
    phidach=90*(1-rdachxy0);
    end
disp(['Geschätzte Phase  phidach = ',num2str(phidach),' Grad'])
disp(' '),disp(' ')
pause,close
J=menualt('Weiterfahren?','Ja','Nein'); clc
end