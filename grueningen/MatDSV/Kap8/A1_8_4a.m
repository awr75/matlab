% M-File  A1_8_4a.M,  Kap.8, Aufgabe 4a 

disp(' '),disp(' ')
f0=input('Frequenz der Sägezahnschwingung in Hz,   f0 =  ');
disp(' ')
fs=input('Abtastfrequenz in Hz   fs =  '); 
disp(' ')
ytab=input('16 Tabellenwerte in Form eines Zeilenvektors eingeben   ytab =  ');
disp(' ')
if length(ytab)~=16
   error('length of ytab is not 16')
end
disp(' '),disp(' ')

% Sägezahn darstellen
T=1/fs; Tend=5/f0; t=0:T:Tend; x=sawtooth(2*pi*f0*t);
subplot(3,1,1),stairs(t,x),axis([0 Tend -1.5 1.5])
ylabel('x')

% ytab darstellen
subplot(3,1,2),stairs(0:15,ytab),axis([0 16 1.1*min(ytab) 1.1*max(ytab)])
ylabel('ytab')

% y berechnen und darstellen
N=length(x); y=zeros(1,N);
for n=1:N,
   i=floor(8*x(n))+9;
   y(n)=ytab(i);
end
subplot(3,1,3),stairs(t,y)
ylabel('y')

pause,close
