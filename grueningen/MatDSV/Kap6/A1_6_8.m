% M-File  A1_6_8.M      
% Lösung zu Band 1, Kap.6, Aufgabe 8 
% 
% Das M-File berechnet die DFT eines Signals, das aus der Summe
% einer Cosinus- und einer Sinusschwingung besteht.


% Eingaben
N=32; Xdach1=-2; k1=4; Xdach2=1; k2=7;

J=1;
while J==1
    
 % Parameterwerte auf Bildschirm darstellen
 close,disp(' '),disp('Parameter:'),disp(' ')
 disp(['1.  ','Länge des Signals                             N       =  ',num2str(N),         '  '])
 disp(['2.  ','Scheitelwert der Cosinusschwingung            Xdach1  =  ',num2str(Xdach1),    '  '])
 disp(['3.  ','Diskrete Frequenz der Cosinusschwingung       k1      =  ',num2str(k1),        '  ']) 
 disp(['4.  ','Scheitelwert der Sinusschwingung              Xdach2  =  ',num2str(Xdach2),    '  '])
 disp(['5.  ','Diskrete Frequenz der Sinusschwingung         k2      =  ',num2str(k2),        '  ']) 
 disp(' ')
 disp(' '), disp('Geben Sie Ihre neuen Parameter ein und schliessen Sie mit der Tastenfolge R E T U R N ab')
 disp(' '), keyboard

% Cosinus- und Sinusschwingung generieren
n=0:N-1; 
x1=Xdach1*cos(k1*n*2*pi/N); x2=Xdach2*sin(k2*n*2*pi/N);
x=x1+x2;
subplot(4,1,1),h=stem(n,x1,'fill');set(h,'linewidth',.5,'MarkerSize',1.5);grid,title('Cosinusschwingung'),xlabel('n')
subplot(4,1,2),h=stem(n,x2,'fill');set(h,'linewidth',.5,'MarkerSize',1.5);grid,title('Sinusschwingung'),xlabel('n')

% DFT berechnen und darstellen
X=fft(x); k=0:(N-1);
subplot(4,1,3),h=stem(k,real(X),'fill');grid,title('Realteil der DFT'),xlabel('k'),set(h,'linewidth',1,'MarkerSize',5);
subplot(4,1,4),h=stem(k,imag(X),'fill');grid,title('Imaginärteil der DFT'),xlabel('k'),set(h,'linewidth',1,'MarkerSize',5);
disp(' '),disp(' ')

pause,close
J=menualt('Weiterfahren?','Ja','Nein'); clc
end