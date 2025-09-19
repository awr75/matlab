% M-File  A1_4_3.M      
% Lösung zu Kap.4, Aufgabe 3 

J=1;while J==1
P=input('Geben Sie die Leistung des Rauschens ein:  P=');
T=1e-4; t=0:T:999*T;
f0=20;
x=sin(2*pi*f0*t)';
e=sqrt(P)*randn(1000,1);
x_plus_e=x+e;
SNR=10*log10(x'*x/(e'*e));
plot(t,x_plus_e'), title(['Das SNR beträgt ',num2str(SNR),' dB']),grid, pause,close
end
