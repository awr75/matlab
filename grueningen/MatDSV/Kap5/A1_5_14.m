% M-File  A1_5_14.M      
% Lösung zu Band 1, Kap.5, Aufgabe 14 


% a)
% Es wird weisses Rauschen der Varianz 1 und der Länge N=64 erzeugt.
% Mittelwert, Leistung und Varianz werden geschätzt.
N=64; n=0:N-1;  
x=randn(1,N); 
subplot(3,1,1),plot(n,x),grid,title('Rauschsignal')
mudachx=mean(x); rohdachhoch2x=mean(x.^2); sigmadachhoch2x=cov(x,1);
Differenz_r_minus_m=rohdachhoch2x-mudachx^2;
disp(' '),disp(' ')
disp(' '),disp(['mudachx             = ',num2str(mudachx)])
disp(' '),disp(['rohdachhoch2x       = ',num2str(rohdachhoch2x)])
disp(' '),disp(['sigmadachhoch2x     = ',num2str(sigmadachhoch2x)])
disp(' '),disp(['Differenz_r_minus_m = ',num2str(Differenz_r_minus_m)])
pause

% b)
% Autokorrelationsfunktion schätzen
m=-N+1:N-1;
rdachstrichxx=xcorr(x,'unbiased'); subplot(3,1,2),plot(m,rdachstrichxx),grid, 
title('Schätzung rdachstrichxx[m] der Autokorrelationsfunktion')
rdachxx=xcorr(x,'biased'); subplot(3,1,3),plot(m,rdachxx),grid
title('Schätzung rdachxx[m] der Autokorrelationsfunktion')
disp(' ')
rohdachhoch2x; rdachstrichxxvon0=rdachstrichxx(N); rdachxxvon0=rdachxx(N);
disp(' '),disp(' ')
disp(' '),disp(['rohdachhoch2x       = ',num2str(rohdachhoch2x)])
disp(' '),disp(['rdachstrichxxvon0   = ',num2str(rdachstrichxxvon0)])
disp(' '),disp(['rdachxxvon0         = ',num2str(rdachxxvon0)])
pause,close

% c)
% I Autokorrelationsfunktionen mitteln
Abfrage=1;
while Abfrage==1
disp(' '),disp(' '),disp(' ')
I=input('Schargrösse eingeben  I=  ');
disp(' ')
rdachxx=zeros(1,2*N-1);
for i=1:I
   x=randn(1,N);rdachxx=xcorr(x,'unbiased')+rdachxx;
end
stem(m,rdachxx/I),grid
title('Gemittelte Autokorrelationsfunktion rdachxx[m]')
pause,close
Abfrage=menualt('Wollen Sie eine neue Schargrösse eingeben?','Ja','Nein');
end

% d)
% N wird auf 512 erhöht und der Mittelwert, die Varianz und die Autokorrelationfunktion werden geschätzt
N=512;   
x=randn(1,N);
subplot(3,1,1),n=0:N-1;plot(n,x),grid
title('Rauschsignal')
mudachx=mean(x); sigmadachhoch2x=cov(x,1);
disp(' '),disp(' ')
disp(' '),disp(['mudachx             = ',num2str(mudachx)])
disp(' '),disp(['sigmadachhoch2x     = ',num2str(sigmadachhoch2x)])
m=-N+1:N-1;
rdachstrichxx=xcorr(x,'unbiased'); subplot(3,1,2),plot(m,rdachstrichxx),grid, 
title('Schätzung rdachstrichxx[m] der Autokorrelationsfunktion')
rdachxx=xcorr(x,'biased'); subplot(3,1,3),plot(m,rdachxx),grid
title('Schätzung rdachxx[m] der Autokorrelationsfunktion')
pause,close

% e)
% Eine Sinusschwingung wird erzeugt und der Mittelwert und der Effektivwert werden geschätzt
f0=1; T=0.05; N=100; t=0:T:(N-1)*T;
x=sin(2*pi*f0*t);
mudachx=mean(x); rhodachx=sqrt(mean(x.^2));
disp(' '),disp(' ')
disp(' '),disp(['mudachx    = ',num2str(mudachx)])
disp(' '),disp(['rhodachx   = ',num2str(rhodachx)])
pause,close

% f)
% Eine Sinus- und eine Cosinusschwingung werden erzeugt
% und die Kreuzkorrelationsfunktion wird geschätzt
x=sin(2*pi*f0*t); y=cos(2*pi*f0*t);
subplot(4,1,1),plot(t,x),grid,title('Sinussignal')
subplot(4,1,2),plot(t,y),grid,title('Cosinussignal')
tau=(-N+1)*T:T:(N-1)*T;
subplot(4,1,3),plot(tau,xcorr(x,y,'unbiased')),grid
title('Erwartungstreue Schätzung rdachxy[m] der Kreuzkorrelationsfunktion')
subplot(4,1,4),plot(tau,xcorr(x,y,'biased')),grid
title('Asymptotisch erwartungstreue Schätzung rdachxy[m] der Kreuzkorrelationsfunktion')
pause,close
