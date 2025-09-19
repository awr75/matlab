% M-File  A1_6_3.M      
% Lösung zu Band 1, Kap.6, Aufgabe 3 
%
% Es wird eine DFT-Matrix generiert und anschliessend mit einem Signalvektor  
% multipliziert. Das Resultat wird mit dem Ergebnis der FFT verglichen.


N=5; W=exp(-j*2*pi/N);

WN=W.^([0:(N-1)]'*[0:(N-1)]);
x=randn(N,1)
X=WN*x
X=fft(x)