% M-File  A1_6_9.M      
% Lösung zu Band 1, Kap.6, Aufgabe 9 
%
% DFT einer Überlagerung von Sinusschwingungen mit Rauschen
% Spektrum mit Rechteckfenster und Kaiser-Fenster

% Eingaben
Udach1=1; f1=990; Udach2=0.01; f2=1010; sigma=0.01; Amin=60; N=1024; 

J=1;
while J==1
    
% Parameterwerte auf Bildschirm darstellen
close,disp(' '),disp('Parameter:'),disp(' ')
disp(['1.  ','Scheitelwert der ersten Sinusschwingung           Udach1  =  ',num2str(Udach1),    ' V '])
disp(['2.  ','Frequenz der ersten Sinusschwingung               f1      =  ',num2str(f1),        ' Hz']) 
disp(['3.  ','Scheitelwert der zweiten Sinusschwingung          Udach2  =  ',num2str(Udach2),    ' V '])
disp(['4.  ','Frequenz der zweiten Sinusschwingung              f2      =  ',num2str(f2),        ' Hz']) 
disp(['5.  ','Streuung (Effektivwert) des Rauschens             sigma   =  ',num2str(sigma),     ' V '])
disp(['6.  ','Minimale Dämpfung der Seitenlappen                Amin    =  ',num2str(Amin),      ' dB '])
disp(['7.  ','Länge der Signale                                 N       =  ',num2str(N),         '   '])
disp(' ')
disp('Die Abtastfrequenz fs ist 4000 Hz')
disp('Die beiden einzugebenden Frequenzen müssen zwischen 800 und 1200 Hz liegen')
disp(' '), disp('Geben Sie Ihre neuen Parameter ein und schliessen Sie mit der Tastenfolge R E T U R N ab')
disp(' '), keyboard

% Signal generieren
fs=4000; T=1/fs; 
t=0:T:(N-1)*T; u1=Udach1*sin(2*pi*f1*t); u2=Udach2*sin(2*pi*f2*t); u3=sigma*randn(1,N);
x=u1+u2+u3; 

% Signalausschnitt der Sinussignale mit Rauschen darstellen
tc=0:10e-6:10e-3;
uc=Udach1*sin(2*pi*f1*tc)+Udach2*sin(2*pi*f2*tc)+sigma*randn(1,1001);
subplot(2,1,1),h=plot(1000*tc,uc);set(h,'linewidth',1.5)
axis([0 10 -2 2]),grid
xlabel('t   [ms]'),ylabel('x(t)   [V]')
title('Zwei Sinussignale mit Rauschen')
pause

% Spektrum mit Rechteckfenster
f=0:fs/N:0.5*fs; X=(2/N)*abs(fft(x)); X=X(1:N/2+1);
close,subplot(2,1,1),h=semilogy(f,X);set(h,'linewidth',1.5)
axis([800 1200 1e-4 1]),grid
xlabel('f  [Hz]')
title('Spektrum (DFT) mit Rechteck-Fenster')

% beta berechnen
if Amin<13.26
         beta=0;
       elseif 13.26<=Amin & Amin<60
         beta=0.7661*(Amin-13.26)^0.4+0.0983*(Amin-13.26);
       else
         beta=0.12438*(Amin+6.3);
       end

% Spektrum mit Kaiser-Fenster
wK=kaiser(N,beta);c3=2/sum(wK);
x=c3*x'.*kaiser(N,beta); X=abs(fft(x)); X=X(1:N/2+1);
subplot(2,1,2),h=semilogy(f,X);set(h,'linewidth',1.5)
axis([800 1200 1e-4 1]),grid
xlabel('f  [Hz]')
title('Spektrum (DFT) mit Kaiser-Fenster')

disp(' '),disp(' ')
pause,close
J=menualt('Weiterfahren?','Ja','Nein'); clc
end
