% M-File  A1_8_9b.M,  Kap.8, Aufgabe 9b 


clc, clear, close


% Parameter eingeben
disp(' '),disp(' ')
I=input('Anzahl gleichverteilte Rauschgeneratoren   I =  '); 
disp(' ')
M=input('Anzahl M Blöcke der Länge N=512,  M =  ');
disp(' '),disp(' ')



% Initialisierung
sigmahat2x=0;
Sxx=zeros(1,512);
fx=zeros(1,20);

% Approximativer Gaussscher Rauschgenerator   
for n=1:M
   if I==1
       x=2*rand(1,512)-1;
   else
   x=1/I*sum(2*rand(I,512)-1);
   end
   fx=hist(x,-.95:.1:.95)+fx;
   sigmahat2x=var(x)+sigmahat2x;
   X=fft(x)/512; X=fftshift(X); Sxx=abs(X).*abs(X)+Sxx;
end


% Berechnung und Ausgabe der numerischen Werte
sigma2x=1/(3*I); sigmax=sqrt(sigma2x);
sigmahat2x=sigmahat2x/M; sigmahatx=sqrt(sigmahat2x);
Sxx=512*Sxx/M; 
fx=fx*20/(512*2*M);
disp(['Vorausgesagte Varianz             sigma2x     =  ',num2str(sigma2x)])
disp(' ')
disp(['Gemessene Varianz                 sigmahat2x  =  ',num2str(sigmahat2x)])
disp(' ')
disp(['Vorausgesagte Standardabweichung  sigmax      =  ',num2str(sigmax)])
disp(' ')
disp(['Gemessene Standardabweichung      sigmahatx   =  ',num2str(sigmahatx)])
pause

% Darstellung
disp(' '),disp(' ')
subplot(3,1,1), xmax=1.2*max(abs(x)); plot(x); axis([0 512  -xmax xmax]); grid
title('Rauschsignal'),ylabel('x[n]')
subplot(3,1,2), bar(-.95:.1:.95,fx); grid
hold on,subplot(3,1,2),xg=-1:.01:1; yg=1/(sqrt(2*pi)*sigmax)*exp(-0.5*(xg/sigmax).^2); plot(xg,yg,'r')
title('Histogramm und gewünschte Wahrscheinlichkeitsdichtefunktion'),ylabel('fx(x)')
subplot(3,1,3), Omega=-pi:2*pi/511:pi; plot(Omega,Sxx); grid
hold on,subplot(3,1,3), plot(Omega, sigma2x*ones(1,length(Omega)),'r')
title('Geschätztes und ideales Leistungsdichtespektrum'), ylabel('Sxx(Omega)')
pause, close

