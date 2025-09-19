% M-File  A1_4_10.M      
% Lösung zu Kap.4, Aufgabe 10

home
disp('')
disp('Entwerfe mit sptool ein FIR-Filter,') 
disp('exportiere es unter dem Namen filt1 in den Speicher')
disp('und schliesse mit der Eingabe R E T U R N ab.')
disp(''),keyboard
set(gcf,'Units','normal','Position',[0.4 0 0.6 0.6])

% Impulsantwort, respektive Filterkoeffizientenvektor plotten
filt1; b=filt1.tf.num'; N=length(b)-1; i=0:N;
disp('Das Bild stellt den Filterkoeffizientenvektor b dar.')
subplot(5,1,1),stem(i,b,'filled'),grid,pause

% Generiere ein zeitdiskretes Eingangssignal der Länge L
L=100; n=0:L-1; x=randn(L,1);
disp('Im neuen Bild ist das Eingangssignal ersichtlich.')
subplot(5,1,2),stem(n,x,'.'),grid,pause

% Ausgangssignal über die Faltung berechnen
disp('Im dritten Bild ist das Ausgangssignal dargestellt, das mittels der Faltung berechnet wurde.')
y1=conv(b,x); Ly1=length(y1); n1=0:Ly1-1;
subplot(5,1,3),stem(n1,y1,'.'),grid,pause

% Ausgangssignal über die Differenzengleichung berechnen
disp('Im vierten Bild ist das Ausgangssignal dargestellt, das mittels der Differenzengleichung berechnet wurde.')
y2=filter(b,1,x); Ly2=length(y2); n2=0:Ly2-1;
subplot(5,1,4),stem(n2,y2,'.'),grid,pause

% Ausgangssignal über das Skalarprodukt berechnen
disp('Im letzten Bild ist das Ausgangssignal dargestellt, das mittels des Skalarprodukts berechnet wurde.')
y3=zeros(L,1); x3data=zeros(N,1); % Initialisierung
for  n3 = 1:L,
   % Bildung des Datenvektors
   x3data=[x(n3);x3data(1:N)];
	% Bildung des Ausgangsabtastwertes
	y3(n3)=b'*x3data;		
end; 
n3=0:L-1; 
subplot(5,1,5),stem(n3,y3,'.'),grid,pause,close
