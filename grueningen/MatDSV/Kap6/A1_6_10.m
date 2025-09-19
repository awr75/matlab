% M-File  A1_6_10.M      
% Lösung zu Band 1, Kap.6, Aufgabe 10 
%
% DFT und ihre Umhüllende eines Signals der Länge N

close, home, colordef white
disp(' '),disp(' ')
disp('Geben Sie analog zu den Beispielen 1 und 2 ein:')
disp('N (gerade), Abtastfrequenz fs und Fenster w, sowie ein Signal')
disp('der Länge N multipliziert mit einem Rechteck- oder Hann-Fenster w')
disp(' '),disp(' ')
disp('Eingabe-Beispiel 1:')
disp(' ')
disp('N=32; fs=1000; w=rectwin(N)''; ...')
disp('f1=100; f2=200; f3=f2+fs/N; T=1/fs; t=0:T:(N-1)*T; ...')
disp('x=cos(2*pi*f1*t)+sin(2*pi*f2*t)+cos(2*pi*f3*t); xw=x.*w; return')
disp(' '),disp(' ')
disp('Eingabe-Beispiel 2:')
disp(' ')
disp('N=32; fs=1000; w=rectwin(N)''; ...')
disp('f1=100; f2=200; f3=f2+fs/N; T=1/fs; t=0:T:(N-1)*T; ...')
disp('x=cos(2*pi*f1*t)+sin(2*pi*f2*t)+cos(2*pi*f3*t); w=hann(N)''; xw=x.*w; return')
disp(' '),disp(' ')

keyboard

% xw darstellen
xdar=zeros(1,N+20); xdar(11:N+10)=xw;
subplot(2,1,1), t=1000*[-10*T:T:(N+9)*T]; stem(t,xdar,'fill', 'MarkerSize',2)
xlabel('t in ms'); title(['Gefenstertes Signal xw,   N = ',num2str(N)])

% DFT und Umhüllende darstellen
absDFT=2/sum(w)*abs(fft(xw)); absDFT=absDFT(1:N/2+1);
subplot(2,1,2), f=0:fs/N:fs/2; stem(f,absDFT,'fill', 'MarkerSize',4)
xlabel('f in Hz'); title('DFT und Umhüllende')
set(gcf,'Units','normal','Position',[0.5 0.1 0.5 0.5])
hold on
xwzerofilled=zeros(1,1024); xwzerofilled(1:N)=xw;
Umhuellende=2/sum(w)*abs(fft(xwzerofilled)); Umhuellende=Umhuellende(1:513);
subplot(2,1,2), f=0:fs/1024:fs/2; plot(f,Umhuellende)

pause,close