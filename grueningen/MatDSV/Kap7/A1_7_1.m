% M-File A1_7_1.M,  Kap.7, Aufgabe 1 
%
% Dieses M-File bestimmt folgende Grössen zu einem linearen Digitalfilter:
% Frequenzgang, Gruppenlaufzeit, Impulsantwort, PN-Diagramm,
% Faltung, sowie das Spektrum (DTFT) des Eingangs- und Ausgangssignals

close, home, colordef black

disp(' '),disp(' ')
disp('Daten in Form eines Zeilenvektors eingeben')
disp(' ')
b=input('Koeffizienten des Zählerpolynoms  b=  ');
disp(' ')
a=input('Koeffizienten des Nennerpolynoms  a=  ');
disp(' ')
x=input('Eingangssignal  x=  ');
disp(' ')

freqz(b,a), pause, close

grpdelay(b,a), pause, close

impz(b,a), title('Impulsantwort h[n]'), pause, close

zplane(b,a), title('PN-Diagramm'), pause, close

N=length(x); n=0:N-1;
plot(n,x); title('Eingangssignal x[n]'), pause, close

y=filter(b,a,x);
plot(n,y); title('Ausgangssignal y[n]'), pause, close

[X,Omega]=dtft(x,4096);
plot(Omega,abs(X));
title('Betrag der zeitdiskreten Fourier-Transformierten des Eingangssignals x[n]')
ylabel('|X(Omega)|'), xlabel('Omega'), pause, close

[Y,Omega]=dtft(y,4096);
plot(Omega,abs(Y));
title('Betrag der zeitdiskreten Fourier-Transformierten des Ausgangssignals y[n]')
ylabel('|X(Omega)|'), xlabel('Omega'), pause, close