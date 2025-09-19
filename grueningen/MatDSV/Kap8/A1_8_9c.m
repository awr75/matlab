% M-File  A1_8_9c.M,  Kap.8, Aufgabe 9c 


clc, clear, close


% Parameter eingeben
disp(' '),disp(' ')
Omega1=input('Untere normierte Durchlasskreisfrequenz   Omega1 =  '); 
disp(' ')
Omega2=input('Obere normierte Durchlasskreisfrequenz    Omega2 =  '); 
disp(' ')
M=input('Anzahl M Blöcke der Länge N=512,  M =  ');
disp(' '),disp(' ')



% Filter entwerfen
if Omega1==0
   [b,a]=ellip(4,0.1,40,Omega2/pi);
else
   [b,a]=ellip(4,0.1,40,[Omega1 Omega2]/pi);    
end

% Initialisierung
zf=zeros(1,length(a)-1);
sigmahat2y=0;
Syy=zeros(1,512);
fy=zeros(1,20);
sigma2x=1;

% Gaussverteiltes Rauschen filtern  
for n=1:M
   x=randn(1,512);
   [y,zf]=filter(b,a,x,zf);
   fy=hist(y,-.95:.1:.95)+fy;
   sigmahat2y=var(y)+sigmahat2y;
   Y=fft(y)/512; Y=fftshift(Y); Syy=abs(Y).*abs(Y)+Syy;
end

% Berechnung und Ausgabe der numerischen Werte
NG=nsgain(b,a); sigma2y=NG*sigma2x; sigmay=sqrt(sigma2y); 
sigmahat2y=sigmahat2y/M;
Syy=512*Syy/M; 
fy=fy*20/(512*2*M);
disp(['Berechnete Varianz             sigma2y     =  ',num2str(sigma2y)])
disp(' ')
disp(['Gemessene Varianz              sigmahat2y  =  ',num2str(sigmahat2y)])
pause

% Darstellung
disp(' '),disp(' ')
subplot(3,1,1), ymax=1.2*max(abs(y)); plot(y); axis([0 512  -ymax ymax]); grid
title('Gefiltertes Rauschsignal'),ylabel('y[n]')
subplot(3,1,2), bar(-.95:.1:.95,fy); grid
hold on,subplot(3,1,2),xg=-1:.01:1; yg=1/(sqrt(2*pi)*sigmay)*exp(-0.5*(xg/sigmay).^2); plot(xg,yg,'r')
title('Histogramm und Wahrscheinlichkeitsdichtefunktion'),ylabel('fy(y)')
subplot(3,1,3), Omega=-pi:2*pi/511:pi; plot(Omega,Syy); grid
hold on,subplot(3,1,3), H=freqz(b,a,Omega); plot(Omega, abs(H).^2,'r:')
title('Geschätztes und ideales Leistungsdichtespektrum am Filterausgang'), ylabel('Syy(Omega)')
pause, close

