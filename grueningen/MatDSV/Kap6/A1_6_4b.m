% M-File  A1_6_4b.M      
% Lösung zu Band 1, Kap.6, Aufgabe 4(b)
%
% Testen der Funktionen goertzel1 und goertzel2


% Signalvektoren generieren
N=5; x1=randn(N,1); x2=sin(2*pi*[0:1/N:(N-1)/N])';

% DFT-Koeffizienten berechnen
X1=zeros(N,1); X2=zeros(N,1);
for k=1:N
   X1(k)=goertzel1(x1,k-1); X2(k)=goertzel1(x2,k-1); 
end
X1,X2
for k=1:N
   X1(k)=goertzel2(x1,k-1); X2(k)=goertzel2(x2,k-1); 
end
X1,X2
X1=fft(x1), X2=fft(x2)
