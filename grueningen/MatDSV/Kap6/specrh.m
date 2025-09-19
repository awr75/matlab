% M-File  specrh.m
%
% Ein Signal, bestehend aus der Überlagerung von zwei Cosinus-Schwingungen, mit den
% Scheitelwerten 1 und den Frequenzen f1 und f2 wird Rechteck- und Hanning-gefenstert.
% Die Anzahl Abtastwerte ist gleich N und die Abtastfrequenz fs beträgt 2000Hz.
% Die gefensterten Signale werden DFT-transformiert und ihre Betragsspektren
% im Nyquistbereich dargestellt.

clear, close

% Die beiden Frequenzen und die Anzahl Abtastwerte eingeben

disp(' '),disp(' ')
disp('Geben Sie zwei Frequenzen im Bereich von 250Hz ein')
f1=input('Erste Frequenz f1 in Hz eingeben  ')
f2=input('Zweite Frequenz f2 in Hz eingeben  ')
disp('Die Abtastfrequenz fs betraegt 2 kHz')
disp(' '),disp(' ')
disp('Geben Sie die Anzahl Abtastpunkte N ein')
N=input('N=  ')


% Das Rechteck-gefensterte und das Hanning-gefensterte Signal
% generieren und darstellen

T=0.5e-3; fs=2e3; 
Abstand_der_beiden_Frequenzen=abs(f2-f1),
Aufloesung_Rechteckf_in_Hz=fs/N,
Aufloesung_Hanningfenster_in_Hz=2*fs/N,pause
t=0:T:(N-1)*T; x=cos(2*pi*f1*t)+cos(2*pi*f2*t); 
xR=x'; 
wH=zeros(N,1);wH(2:N-1)=hanning(N-2);c2=2/sum(wH); xH=x'.*wH;
subplot(2,1,1),plot(1e3*t,xR),grid
xlabel('t   [ms]'),title('Signal mit Rechteckfenster  ci=c1=1')
subplot(2,1,2),plot(1e3*t,xH),grid
xlabel('t   [ms]')
title('Signal mit Hanningfenster  ci=c1=1'), pause


% Spektrum mit Rechteckfenster

f=0:fs/N:0.5*fs; XR=(2/N)*abs(fft(xR)); XR=XR(1:N/2+1);
close,subplot(2,1,1),plot(f,XR),grid
xlabel('f  [Hz]')
title('Betragsspektrum mit Rechteck-Fenster  ci=c2')


% Spektrum mit Hanning-Fenster

XH=c2*abs(fft(xH)); XH=XH(1:N/2+1);
subplot(2,1,2),plot(f,XH),grid
xlabel('f  [Hz]')
title('Betragsspektrum mit Hanning-Fenster  ci=c2')
pause,close