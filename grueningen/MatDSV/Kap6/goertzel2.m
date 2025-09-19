function Xk=goertzel2(x,k)
N=length(x);
a=2*cos(2*pi*k/N); WkN=exp(-j*2*pi*k/N);
[y,v]=filter(1,[1 -a 1],x);
Xk=v(1)-WkN*y(N);