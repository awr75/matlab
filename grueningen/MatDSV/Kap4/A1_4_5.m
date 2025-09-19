% M-File  A1_4_5.M      
% Lösung zu Kap.4, Aufgabe 5

home
x=[0 .5 1 1 1 1]'
h=[0 -.5 -.5 1]'
y=conv(x,h), Ly=length(y); n=0:Ly-1;
stem(n,y,'filled'),title('Faltung von x mit h'),grid,pause,close

[y,F] = gconv(x,h);