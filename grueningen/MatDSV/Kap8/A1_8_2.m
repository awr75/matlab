% M-File  A1_8_2.M,  Kap.8, Aufgabe 2 

disp(' '), disp(' ')
M=input('Anzahl Sägezahnschwingungen M,   M =  ');
disp(' ')
N=input('Anzahl Sinusschwingungen N (N<<M),   N =  '); 
disp(' ')
fpass=input('Normierte Durchlassfrequenz des TP-Filters,  fpass/fsample =  ');
disp(' '),disp(' '),disp(' ')

% Sägezahn darstellen
x=sawtooth(2*pi*.01*[0:100*M-1]);
subplot(4,1,1),plot([0:100*M-1],x),axis([0 100*M-1 -1.5 1.5])

% Sinus darstellen
f0=N/M; s=sin(2*pi*f0*[0:M-1]);
subplot(4,1,2),plot([0:M-1],s),axis([0 M-1 -1.5 1.5])

% Modulierte Rechteckschwingung
s=-s;  % s: Schwelle
s=s'*ones(1,100);s=s';s=s(:);s=s';  % s soll die gleiche Länge wie x haben
y=x>s; y=2*y-1; % Erzeugung des modulierten Rechtecks
subplot(4,1,3), plot(y),axis([0 100*M-1 -1.5 1.5])

% Gefilterte Rechteckschwingung
[b,a]=ellip(4,.5,40,2*fpass);
y=filter(b,a,y);
subplot(4,1,4), plot(y),axis([0 100*M-1 -1.5 1.5])

pause,close
