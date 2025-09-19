function Xk=goertzel1(x,k)
% Initialisierung
N=length(x);
a=2*cos(2*pi*k/N); WkN=exp(-j*2*pi*k/N);
v=[0;0;0]; x(N+1)=0;
% Rekursion
for n=1:N+1
   v(3)=v(2); v(2)=v(1); v(1)=a*v(2)-v(3)+x(n);
end
% Endwert
Xk=v(1)-WkN*v(2);
