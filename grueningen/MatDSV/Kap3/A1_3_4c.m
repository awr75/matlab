% M-File  A1_3_4c.m      
% Lösung zu Kap.3, Aufgabe 4(c)
%
% Frequenzgang des RC-Glieds


% Berechnung der Zeitkonstanten
fmax=500;D=.5;
RC=sqrt(10^(-D/-10)-1)/(2*pi*fmax)

% Übertragungsfunktion bestimmen
H=tf(1,[RC 1])

% Frequenzgang plotten
freqs(1,[RC 1]); pause,close
f=logspace(-2+log10(fmax),log10(fmax));
H=freqs(1,[RC 1],2*pi*f); HindB=20*log10(abs(H)); 
semilogx(f,HindB); 
title('Amplitudengang in dB'), xlabel('f in Hz')
pause,close