% M-File  ApproxinvFourier
%
% Dieses M-File approximiert die inverse Fourier-Transformierte der Sinc-Spektrums 
% durch eine Summe von komplexen Exponentialfunktionen

% -------------------------------- 11.12.09 / DvG --------------------------------

close, home, colordef black

disp(' ')
disp('Approximation der inversen Fourier-Transformierten des Sinc-Spektrums')
disp('mit T0=1 und A=1 durch eine Summe von komplexen Exponentialschwingungen')
disp('und durch eine Summe von Cosinusschwingungen')
disp('-----------------------------------------------------------------------')
disp(' '),disp(' ')
disp('Geben Sie ein:')
disp(' ')
disp('Das Frequenzintervall Deltaf und die Anzahl K von Exponentialschwingungen')
disp('(K muss eine gerade Zahl sein)')
disp(' '),disp(' ')


disp('Eingabe-Beispiel 1:')
disp(' ')
disp('Deltaf=0.1; K=200; return')
disp(' '), disp(' ')
disp('Eingabe-Beispiel 2:')
disp(' ')
disp('Deltaf=0.05; K=800; return')
disp(' '), disp(' ')
disp('Eingabe-Beispiel 3:')
disp(' ')
disp('Deltaf=0.2; K=400; return')
disp(' '), disp(' ')

keyboard

% Sinc-Spektrum als Fourier-Transformierte des Rechteckpulses
subplot(4,1,1); f=-(K+1)/2*Deltaf:0.005:(K+1)/2*Deltaf; h=plot(f,sinc(f));
title('Sinc-Funktion als Spektrum'), xlabel('f/Hz'), 
set(h,'linewidth',1.5); axis([-K/2*Deltaf K/2*Deltaf -0.5 1.5]),grid

% Approximiertes Sinc-Spektrum als approcimative Fourier-Transformierte des Rechteckpulses
subplot(4,1,2); f=-K/2*Deltaf+Deltaf/2:Deltaf:K/2*Deltaf-Deltaf/2; X=sinc(f); h=stairs(f,X);
title(['Approximierte Sinc-Funktion als Spektrum (Deltaf= ',num2str(Deltaf),' Hz)']), xlabel('f/Hz'), 
set(h,'linewidth',1.5); axis([-(K-1)/2*Deltaf (K-1)/2*Deltaf -0.5 1.5]),grid

% Approximative inverse Fourier-Transformierte als Summe von K Exponentialschwingungen
Deltat=0.01; xapprox=zeros(1,401);
for n=1:401;
xapproxexp(n)=real(Deltaf*sum(X.*exp(j*2*pi*f*Deltat*(n-201))));
end
subplot(4,1,3); t=-2:0.01:2; h=plot(t,xapproxexp);
title(['Approximative, inverse Fourier-Transformierte als Summe von ',num2str(K),' Exponentialschwingungen']), xlabel('t/s'), 
set(h,'linewidth',1.5); axis([-2 2 -0.5 1.5]),grid

% Approximative inverse Fourier-Transformierte als Summe von K/2 Cosinusschwingungen
Deltat=0.01; xapprox=zeros(1,401);
for n=1:401;
xapproxcos(n)=Deltaf*sum(X.*cos(2*pi*f*Deltat*(n-201)));
end
subplot(4,1,4); t=-2:0.01:2; h=plot(t,xapproxcos);
title(['Approximative, inverse Fourier-Transformierte als Summe von ',num2str(K/2),' Cosinusschwingungen']), xlabel('t/s'), 
set(h,'linewidth',1.5); axis([-2 2 -0.5 1.5]),grid
set(gcf,'Units','normal','Position',[0 0 1 1]), pause,close

