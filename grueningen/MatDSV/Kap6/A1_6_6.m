% M-File  A1_6_6.M      
% Lösung zu Band 1, Kap.6, Aufgabe 6 
%
% Dieses M-File stellt die Betragsspektren des Rechteck-, 
% des Hanning- und des Kaiser-Fensters dar.

clear, close

% N, fs und Amin des Kaiser-Fensters eingeben.
disp(' '),disp(' ')
disp('Eingabe der Abtastfrequenz, der Anzahl Abtastwerte')
disp('und der Seitenlappen-Dämpfung des Kaiserfensters'),disp(' ')
fs=input('Abtastfrequenz fs in Hz eingeben  '),disp(' ')
N=input('Anzahl Abtastwerte N eingeben  '),disp(' ')
Amin=input('Minimale Dämpfung Amin der Nebenlappen in dB eingeben:  ')
disp(' ')

% Logarithmisches Betragsspektrum des Rechteckfensters darstellen
f=linspace(-0.5*fs,0.5*fs,1024);
wR=boxcar(N);c2=1/sum(wR);
WR=freqz(c2*wR,1,f,fs);
subplot(3,1,1),plot(f,20*log10(abs(WR)));
title('Rechteckfenster')
axis([-.5*fs .5*fs -60 20]),grid

% Logarithmisches Betragsspektrum des Hannfensters darstellen
wH=hann(N);c2=1/sum(wH);
WH=freqz(c2*wH,1,f,fs);
subplot(3,1,2),plot(f,20*log10(abs(WH)));
title('Hannfenster')
axis([-.5*fs .5*fs -120 20]),grid

% Logarithmisches Betragsspektrum des Kaiserfensters darstellen
if Amin<13.26
   beta=0;
elseif Amin<60
   beta=0.76609*(Amin-13.26)^0.4+0.09834*(Amin-13.26);
else
   beta=0.12438*(Amin+6.3);
end
wK=kaiser(N,beta);c2=1/sum(wK);
WK=freqz(c2*wK,1,f,fs);
subplot(3,1,3),plot(f,20*log10(abs(WK)));
title('Kaiserfenster')
axis([-.5*fs .5*fs -120 20]),grid



pause,close