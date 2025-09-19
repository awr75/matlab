% M-File A1_7_6.M,  Kap.7, Aufgabe 6 
%
% Dieses M-File zeichnet den Frequenzgang und das Ausgangssignal zu 
% einem IIR-Filter.
% Das Ausgangssignal wird mithilfe des Befehls "filter" und
% durch Programmierung einer Kaskaden-Struktur berechnet.

close, home, colordef black

% Teilaufgabe (a)
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

N=length(x); n=0:N-1;
subplot(2,1,1), plot(n,x); title('Eingangssignal x[n]')
yD=filter(b,a,x);


% Teilaufgabe (b)

% Kaskaden-Algorithmus initialisieren
sos=tf2sosI(b,a,'up','inf');
N=length(x); L=length(sos(:,1));
y=zeros(3,L+1);
w=zeros(L,1);
yK=zeros(N,1);

% Kaskaden-Simulation durchführen
for n=1:N
   y(2:3,:)=y(1:2,:);  % Delay
   y(1,1)=x(n);        % Neuer Abtastwert einlesen
   for l=1:L           
      w(l)=sos(l,1:3)*y(1:3,l);             % Multiply-Add-Operationen   
      y(1,l+1)=w(l)-sos(l,5:6)*y(2:3,l+1);  % durchführen
   end
   yK(n)=y(1,L+1);    % Ausgangsabtastwert abspeichern
end

% Signale darstellen
n=0:N-1; subplot(2,1,2), plot(n,yD,n,yK); 
title('Ausgangssignale Direktform- (gelb) und Kaskaden-Filter (magenta)'), pause, close

