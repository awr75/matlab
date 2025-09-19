% M-File  A1_8_6.M,  Kap.8, Aufgabe 6      


% z-Transformierte der kausalen Sinusfolge bestimmen
syms X x Omega0 phi n  z
x=sin(Omega0*n+phi)
X=ztrans(x,n,z); 
pretty(X)

% Parameter eingeben
disp(' '),disp(' ')
fs=input('Abtastfrequenz in Hz,   fs =  ');
disp(' ')
f0=input('Frequenz in Hz,   f0 =  '); 
disp(' ')
phi=input('Nullphasenwinkel in Grad,   phi =  '); phi=phi/180*pi;
disp(' ')
W=input('Wortlänge,   W =  ');
disp(' ')
N=input('Länge des Ausgangsignals,    N =  ');
disp(' ')
Ny=input('Länge des dargestellten Ausgangssignals,   Ny =  ');
disp(' '),disp(' ')

% Algorithmus initialisieren
Omega0=2*pi*f0/fs;
b0=sin(phi); b0Q=quantsig(b0,W,'sat','round');
b1=sin(Omega0-phi); b1Q=quantsig(b1,W,'sat','round');
a1=-2*cos(Omega0); 
a1s=a1/2; a2s=1/2; zweihochL=2;
while -a1s<1/2
   a1s=2*a1s; a2s=2*a2s; zweihochL=zweihochL/2;
end   
a1s=quantsig(a1s,W,'none','round');
yr=zeros(Ny,1); ya=zeros(Ny,1); 


% Simulation des idealen Sinusoszillators
   
% Simulation für die ersten Ny Punkte durchführen
y=sin(Omega0*[0:Ny-1]'+phi);
% Simulation für die restlichen Punkte durchführen
for n=Ny+1:N
   yneu=sin(Omega0*n+phi);
   y=[y(2:Ny);yneu];
end


% Simulation mit Runden
   
% Simulation für die ersten Ny Punkte durchführen
yr(1)=b0Q;
yr(2)=b1Q+zweihochL*(-a1s*yr(1)); yr(2)=quantsig(yr(2),W,'sat','round');
for n=3:Ny
   yr(n)=zweihochL*(-a1s*yr(n-1)-a2s*yr(n-2)); yr(n)=quantsig(yr(n),W,'sat','round');
end
% Simulation für die restlichen Punkte durchführen
for n=Ny+1:N
   yneu=zweihochL*(-a1s*yr(Ny)-a2s*yr(Ny-1)); yneu=quantsig(yneu,W,'sat','round');
   yr=[yr(2:Ny);yneu];
end


% Simulation mit Abschneiden

% Simulation für die ersten Ny Punkte durchführen
ya(1)=b0Q;
ya(2)=b1Q+zweihochL*(-a1s*ya(1)); ya(2)=quantsig(ya(2),W,'sat','floor');
for n=3:Ny
   ya(n)=zweihochL*(-a1s*ya(n-1)-a2s*ya(n-2)); ya(n)=quantsig(ya(n),W,'sat','floor');
end
% Simulation für die restlichen Punkte durchführen
for n=Ny+1:N
   yneu=zweihochL*(-a1s*ya(Ny)-a2s*ya(Ny-1)); yneu=quantsig(yneu,W,'sat','floor');
   ya=[ya(2:Ny);yneu];
end  

% Signale darstellen
n=N-Ny:N-1; subplot(2,1,1), plot(n,ya,'b',n,yr,'r',n,y,'g'); grid
title('Ausgangssignale der Oszillatoren, grün:ideal,  rot: gerundet,  blau: abgeschnitten')
xlabel('n'),ylabel('y[n], yr[n], ya[n]')

pause, close

% Die eingegebene mit der berechneten und gemessenen Frequenz vergleichen
disp(''),disp('')
disp(['Eingegebene Frequenz','  f0 = ',num2str(f0),' Hz'])
f0b=fs*acos(a1s*zweihochL/-2)/(2*pi);
disp(['Berechnete Frequenz','  f0b = ',num2str(f0b),' Hz'])
f0y=freqest(y,fs);
disp(['Gemessene Frequenz von y','   f0y = ',num2str(f0y),' Hz'])
f0r=freqest(yr,fs);
disp(['Gemessene Frequenz von yr','  f0r = ',num2str(f0r),' Hz'])
f0a=freqest(ya,fs);
disp(['Gemessene Frequenz von ya','  f0a = ',num2str(f0a),' Hz'])
disp(''),disp('')