% M-File  A1_4_7.M      
% L�sung zu Kap.4, Aufgabe 7 
%
% Achtung: Der Befehl "ztrans" setzt immer voraus, dass die Folge kausal ist!

syms X x Omega n  z

x=sin(Omega*n)
X=ztrans(x,n,z);
pretty(X),pause

x=cos(Omega*n)
X=ztrans(x,n,z);
pretty(X),pause

x=exp(j*Omega*n)
X=ztrans(x,n,z);
pretty(X)
disp(' ')
pause
disp(' '),disp('Diese z-Transformierte h�tte man aus den obigen zwei')
disp('�ber das Linearit�tstheorem (4.50) und die Eulersche Formel (2.2)')
disp('bestimmen k�nnen.')