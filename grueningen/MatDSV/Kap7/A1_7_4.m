% M-File A1_7_4.M,  Kap.7, Aufgabe 4 
%
% Dieses M-File entwirft zwei FIR-Differentiatoren vom Typ 3 und vom Typ 4.
% Es stellt ihre Impulsantworten und ihre Amplitudengänge dar,
% erzeugt zwei Eingangssignale und differenziert sie.


close, colordef black

b3=firpm(22,[0 .8],[0 .4],'differentiator');
b4=firpm(11,[0 .8],[0 .4],'differentiator');


subplot(2,1,1), impz(b3,1), title('Impulsantwort FIR-Differentiator Typ 3')
subplot(2,1,2), impz(b4,1), title('Impulsantwort FIR-Differentiator Typ 4')
pause, close


[H,f]=freqz(b3,1,512,1);
subplot(2,1,1), plot(f,abs(H)), grid
title('Amplitudengang des FIR-Differentiators Typ 3')
[H,f]=freqz(b4,1,512,1);
subplot(2,1,2), plot(f,abs(H)), grid
title('Amplitudengang des FIR-Differentiators Typ 4'), pause, close


n=0:301; x=square(2*pi*.01*n);
subplot(2,1,1), plot(n,x),title('Rechteck als Eingangssignal x[n]')
y=filter(b3,1,x);
subplot(2,1,2), plot(n,y); title('Ausgangssignal y[n] des FIR-Differentiators Typ 3'), pause, close

subplot(2,1,1), plot(n,x),title('Rechteck als Eingangssignal x[n]')
y=filter(b4,1,x);
subplot(2,1,2), plot(n,y); title('Ausgangssignal y[n] des FIR-Differentiators Typ 4'), pause, close


n=0:1000; x=chirp(n,0,1000,0.1,'linear',-90); 
subplot(2,1,1), plot(n,x),title('Chirp als Eingangssignal x[n], fstart=0, fstop=0.1')
y=filter(b3,1,x);
subplot(2,1,2), plot(n,y); title('Ausgangssignal y[n] des FIR-Differentiators Typ 3'), pause, close

subplot(2,1,1), plot(n,x),title('Chirp als Eingangssignal x[n], fstart=0, fstop=0.1')
y=filter(b4,1,x);
subplot(2,1,2), plot(n,y); title('Ausgangssignal y[n] des FIR-Differentiators Typ 4'), pause, close

