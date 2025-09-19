% M-File  A1_8_8.M,  Kap.8, Aufgabe 8    

% Parameter eingeben
disp(' '),disp(' ')
fs=input('Abtastfrequenz in Hz,   fs =  ');
disp(' ')
f0=input('Frequenz in Hz,   f0 =  '); 
disp(' ')
W=input('Wortlänge,   W =  ');
disp(' ')
N=input('Länge des Ausgangsignals,    N =  ');
disp(' ')
Ny=input('Länge des dargestellten Ausgangssignals,   Ny =  ');
disp(' ')

% Algorithmus initialisieren
Omega0=2*pi*f0/fs;
b=sin(Omega0); bQ=quantsig(b,W,'sat','round');
a=cos(Omega0); aQ=quantsig(a,W,'sat','round');
y1r=zeros(Ny,1); y2r=zeros(Ny,1); 


% Simulation des idealen Sinusoszillators
   
% Simulation für die ersten Ny Punkte durchführen
y1=cos(Omega0*[0:Ny-1]'); y2=sin(Omega0*[0:Ny-1]');
% Simulation für die restlichen Punkte durchführen
for n=Ny+1:N
   y1neu=cos(Omega0*n);
   y1=[y1(2:Ny);y1neu];
   y2neu=sin(Omega0*n);
   y2=[y2(2:Ny);y2neu];
end


% Simulation mit Runden
   
% Simulation für die ersten Ny Punkte durchführen
y1r(1)=1; y1r(1)=quantsig(y1r(1),W,'sat','round'); 
y2r(1)=0; y2r(1)=quantsig(y2r(1),W,'sat','round');
for n=2:Ny
   y1r(n)=aQ*y1r(n-1)-bQ*y2r(n-1); y1r(n)=quantsig(y1r(n),W,'sat','round');
   y2r(n)=bQ*y1r(n-1)+aQ*y2r(n-1); y2r(n)=quantsig(y2r(n),W,'sat','round');
end
% Simulation für die restlichen Punkte durchführen
for n=Ny+1:N
   y1rneu=aQ*y1r(Ny)-bQ*y2r(Ny); y1rneu=quantsig(y1rneu,W,'sat','round');
   y2rneu=bQ*y1r(Ny)+aQ*y2r(Ny); y2rneu=quantsig(y2rneu,W,'sat','round');
   y1r=[y1r(2:Ny);y1rneu]; y2r=[y2r(2:Ny);y2rneu];
end


% Signale darstellen
n=N-Ny:N-1; subplot(2,1,1), plot(n,y1r,'r',n,y2r,'r:',n,y1,'g',n,y2,'g:'); grid
title('Ausgangssignale der Oszillatoren,  grün:ideal,  rot: gerundet')
xlabel('n'),ylabel('y1[n], y2[n], y1r[n], y2r[n]')

pause, close

disp(''),disp('')
disp(['Eingegebene Frequenz','  f0 = ',num2str(f0),' Hz'])
fsin=fs*asin(bQ)/(2*pi);fcos=fs*acos(aQ)/(2*pi); f0b=0.5*(fsin+fcos);
disp(['Berechnete Frequenz','  f0b = ',num2str(f0b),' Hz'])
f0y=freqest(y1,fs);
disp(['Gemessene Frequenz der idealen Sinusschwingung','  f0y = ',num2str(f0y),' Hz'])
f0g=freqest(y1r,fs);
disp(['Gemessene Frequenz der Oszillator-Sinusschwingung','  f0g = ',num2str(f0g),' Hz'])

