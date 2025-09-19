% M-File  A1_5_16.M      
% Lösung zu Band 1, Kap.5, Aufgabe 16 
% 
% Simuliert die Ortung eines Lecks mithlfe der Korrelation
% (siehe Kap. 1.3.1).


% Eingaben
l=30; a=10; fs=32000; N=1024; SNR=40; v=1480;

J=1;
while J==1
    
 % Parameterwerte auf Bildschirm darstellen
 close,disp(' '),disp('Parameter:'),disp(' ')
 disp(['1.  ','Rohrlänge                        l   =  ',num2str(l),   ' m  ']) 
 disp(['2.  ','Leckabstand                      a   =  ',num2str(a),    ' m  '])
 disp(['3.  ','Abtastfrequenz                   fs  =  ',num2str(fs),    ' Hz '])
 disp(['4.  ','Signallänge                      N   =  ',num2str(N), '        '])
 disp(['5.  ','Signal to Noise Ratio            SNR =  ',num2str(SNR),   ' dB '])
 disp(' ')
 disp(' '), disp('Geben Sie Ihre neuen Parameter ein und schliessen Sie mit der Tastenfolge R E T U R N ab')
 disp(' '), keyboard

 
if a>l
    error('Der Leckabstand ist zu gross')
end
if N<l/v*fs
    error('Die Anzahl Abtastwerte muss grösser sein')
end

 
% Messsignale x und y generieren
T=1/fs; b=l-a; sigmanutz=1; sigmanoise=sigmanutz*10^(-SNR/20); 
Leckgeraeusch=sigmanutz*randn(1,2*N);
na=round(a/(v*T)); nb=round(b/(v*T)); % Das Leckgeräusch kommt um na, 
                                      % resp. nb Abtastintervalle verzögert bei A, resp. B, an.   
x=Leckgeraeusch(N+1-na:2*N-na)+sigmanoise*randn(1,N);
y=Leckgeraeusch(N+1-nb:2*N-nb)+sigmanoise*randn(1,N);
t=0:T:(N-1)*T;
subplot(3,1,1),plot(1000*t,x),grid,title('Messsignal x(t)'), xlabel('t in ms')
subplot(3,1,2),plot(1000*t,y),grid,title('Messsignal y(t)'), xlabel('t in ms')

% Kreuzkorrelationsfunktion schätzen
m=-N+1:N-1; tau=m*T; rdachxy=xcorr(y,x,'biased'); 
subplot(3,1,3),plot(1000*tau,rdachxy),grid, 
title('Schätzung rdachxy(tau) der Kreuzkorrelationsfunktion'), xlabel('tau in ms')

set(gcf,'Units','normal','Position',[0.45 0.05 0.5 0.5])

% Leckortung
disp(' '),disp(' '),disp(' ')
[rdachxymax,mmax]=max(rdachxy); 
Deltatau=(mmax-N)*T; adach=0.5*(l-v*Deltatau);
disp(['Geschätzte Laufzeitdifferenz   Deltatau = ',num2str(Deltatau*1000),' ms'])
disp(['Geschätzter Leckabstand        adach    = ',num2str(adach),' m'])
disp(' '),disp(' ')
pause,close
J=menualt('Weiterfahren?','Ja','Nein'); clc
end