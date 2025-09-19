% M-File  Tiefpass2Ord
%
% Dieses M-File verlangt die Position eines komplexen Polpaars, zeichnet den Betrag
% der Übertragungsfunktion und berechnet die Impuls- und Schrittantwort
% -------------------------------- 12.04.10 / DvG  [MGT03] --------------------------------


% Impulsantwort aufgrund des PN-Diagramms berechnen und darstellen

clear, close all, home, colordef black
set(gcf,'Units','normal','Position',[0.4 0.1 0.5 0.5])

subplot(121)
rmax=+1; rmin=-3; imax=+4; imin=-imax;
axis([rmin rmax imin imax]); hold on;
axis('square'), title('PN-Diagramm'); xlabel('Realteil/s^-1'); ylabel('Imaginärteil/s^-1'); grid

subplot(122)
tmax=5; dt=0.001; t=0:dt:tmax;
axis([0 tmax -4 +4]); title('Impulsantwort'), xlabel('t/s'), ylabel('h(t)')
hold on

disp(' '); disp('Impulsantwort darstellen.'); disp(' ')
disp('Geben Sie durch Drücken der linken Maustaste die Polpositionen ein.') 
disp('Geben Sie die Polposition mit der rechten Maustaste ein, wenn Sie weiterfahren wollen.'),disp(' ')

subplot(121)
[x,y] = ginput(1);
if x>rmax, x=rmax, end; if x<rmin, x=rmin, end;
if y>imax, y=imax, end; if y<imin, y=imin, end;
l1=line('Xdata',x,'Ydata',y,'LineStyle','x','Color','y','EraseMode','xor');
l2=line('Xdata',x,'Ydata',-y,'LineStyle','x','Color','y','EraseMode','xor');

subplot(122)
den=poly([x+j*y x-j*y]);
omega0=sqrt(den(3)); f0=omega0/(2*pi); feigen=abs(y)/(2*pi); zeta=den(2)/(2*omega0);
disp(['Resonanzkreisfrequenz omega0= ',num2str(omega0),' s^-1'])
disp(['Resonanzfrequenz          f0= ',num2str(f0),' Hz'])
disp(['Eigenfrequenz         feigen= ',num2str(feigen),' Hz'])
disp(['Dämpfungsfaktor         zeta= ',num2str(zeta)])
num=omega0^2; [YY,XX]=impulse(num,den,t); 
l3=line('Xdata',t,'Ydata',YY(:,1),'LineStyle','-','Color','y','EraseMode','xor');

but=1;
while but==1
	subplot(121)
	[x,y,but]=ginput(1);
	if x>rmax, x=rmax; end;	if x<rmin, x=rmin; end;
	if y>imax, y=imax; end;	if y<imin, y=imin; end;
	set(l1,'Xdata',x,'Ydata',y); set(l2,'Xdata',x,'Ydata',-y);

	subplot(122)
	den=poly([x+j*y x-j*y]);
    home;disp(' '),disp('Impulsantwort darstellen.'),disp(' ')
    disp('Geben Sie durch Drücken der linken Maustaste die Polpositionen ein.') 
    disp('Geben Sie die Polposition mit der rechten Maustaste ein, wenn Sie weiterfahren wollen.'),disp(' ')
	omega0=sqrt(den(3)); f0=omega0/(2*pi); feigen=abs(y)/(2*pi); zeta=den(2)/(2*omega0);
    disp(['Resonanzkreisfrequenz omega0= ',num2str(omega0),' s^-1'])
    disp(['Resonanzfrequenz          f0= ',num2str(f0),' Hz'])
    disp(['Eigenfrequenz         feigen= ',num2str(feigen),' Hz'])
    disp(['Dämpfungsfaktor         zeta= ',num2str(zeta)])
	num=omega0^2; [YY,XX]=impulse(num,den,t);
	set(l3,'Xdata',t,'Ydata',YY(:,1));
end


% Schrittantwort aufgrund des PN-Diagramms berechnen und darstellen

close, home
set(gcf,'Units','normal','Position',[0.4 0.1 0.5 0.5])

subplot(121)
rmax=+1; rmin=-3; imax=+4; imin=-imax;
axis([rmin rmax imin imax]); hold on;
axis('square'), title('PN-Diagramm'); xlabel('Realteil/s^-1'); ylabel('Imaginärteil/s^-1'); grid

subplot(122)
tmax=5; dt=0.001; t=0:dt:tmax;
axis([0 tmax 0 +2]); title('Schrittantwort'), xlabel('t/s'), ylabel('h(t)')
hold on

disp(' '); disp('Schrittantwort darstellen.'); disp(' ')
disp('Geben Sie durch Drücken der linken Maustaste die Polpositionen ein.') 
disp('Geben Sie die Polposition mit der rechten Maustaste ein, wenn Sie weiterfahren wollen.'),disp(' ')

subplot(121)
[x,y] = ginput(1);
if x>rmax, x=rmax, end; if x<rmin, x=rmin, end;
if y>imax, y=imax, end; if y<imin, y=imin, end;
l1=line('Xdata',x,'Ydata',y,'LineStyle','x','Color','y','EraseMode','xor');
l2=line('Xdata',x,'Ydata',-y,'LineStyle','x','Color','y','EraseMode','xor');

subplot(122)
den=poly([x+j*y x-j*y]); omega0=sqrt(den(3)); f0=omega0/(2*pi); feigen=abs(y)/(2*pi); zeta=den(2)/(2*omega0);
disp(['Resonanzkreisfrequenz omega0= ',num2str(omega0),' s^-1'])
disp(['Resonanzfrequenz          f0= ',num2str(f0),' Hz'])
disp(['Eigenfrequenz         feigen= ',num2str(feigen),' Hz'])
disp(['Dämpfungsfaktor         zeta= ',num2str(zeta)])
num=omega0^2; [YY,XX]=step(num,den,t); 
l3=line('Xdata',t,'Ydata',YY(:,1),'LineStyle','-','Color','y','EraseMode','xor');

but=1;
while but==1
	subplot(121)
	[x,y,but]=ginput(1);
	if x>rmax, x=rmax; end;	if x<rmin, x=rmin; end;
	if y>imax, y=imax; end;	if y<imin, y=imin; end;
	set(l1,'Xdata',x,'Ydata',y); set(l2,'Xdata',x,'Ydata',-y);

	subplot(122)
	den=poly([x+j*y x-j*y]);
	home;disp(' '),disp('Schrittantwort darstellen.'),disp(' ')
    disp('Geben Sie durch Drücken der linken Maustaste die Polpositionen ein.') 
    disp('Geben Sie die Polposition mit der rechten Maustaste ein, wenn Sie weiterfahren wollen.'),disp(' ')
    omega0=sqrt(den(3)); f0=omega0/(2*pi); feigen=abs(y)/(2*pi); zeta=den(2)/(2*omega0);
    disp(['Resonanzkreisfrequenz omega0= ',num2str(omega0),' s^-1'])
    disp(['Resonanzfrequenz          f0= ',num2str(f0),' Hz'])
    disp(['Eigenfrequenz         feigen= ',num2str(feigen),' Hz'])
    disp(['Dämpfungsfaktor         zeta= ',num2str(zeta)]), disp(' ')
    num=omega0^2; [YY,XX]=step(num,den,t);
	set(l3,'Xdata',t,'Ydata',YY(:,1));
end


% Übertragungsfunktion aufgrund des PN-Diagramms berechnen und darstellen

close all, home
f1=figure; set(f1,'Units','normal','Position',[0.1 0.2 0.3 0.3])
rmax=0; rmin=-4; imax=+4; imin=-imax;
axis([rmin rmax imin imax]); hold on;
axis('square'), title('PN-Diagramm'); xlabel('Re(s)/s^-1'); ylabel('Im(s)/s^-1'); grid

disp(' '),disp('Übertragungsfunktion darstellen.'),disp(' ')
disp('Geben Sie durch Drücken der linken Maustaste die Polpositionen ein.') 
disp('Geben Sie die Polposition mit der rechten Maustaste ein, wenn Sie weiterfahren wollen.'),disp(' ')

[x,y]=ginput(1);
if x>rmax, x=rmax, end; if x<rmin, x=rmin, end;
if y>imax, y=imax, end; if y<imin, y=imin, end;
l1=line('Xdata',x,'Ydata',y,'LineStyle','x','Color','y','EraseMode','xor');
l2=line('Xdata',x,'Ydata',-y,'LineStyle','x','Color','y','EraseMode','xor');

f2=figure; set(f2,'Units','normal','Position',[0.45 0.1 0.5 0.5])
den=poly([x+j*y x-j*y]);
omega0=sqrt(den(3)); f0=omega0/(2*pi); feigen=abs(y)/(2*pi); zeta=den(2)/(2*omega0);
disp(['Resonanzkreisfrequenz omega0= ',num2str(omega0),' s^-1'])
disp(['Resonanzfrequenz          f0= ',num2str(f0),' Hz'])
disp(['Eigenfrequenz         feigen= ',num2str(feigen),' Hz'])
disp(['Dämpfungsfaktor         zeta= ',num2str(zeta)])
num=omega0^2; 
rx= rmin:0.1:rmax; ix = imin:0.1:imax; [rrx,iix]=meshgrid(rx,ix); xx=rrx+j*iix;
z=zeros(size(xx)); nn=max(size(rx));
for jj=1:nn; z(:,jj)=polyval(den,xx(:,jj)); end
zz=20*log10(num./abs(z)); h=surf(rx,ix,zz); hold on;
maxz=max(max(zz))+10; plot3([x x],[-y -y],[-40 maxz]); plot3([x x],[y y], [-40 maxz]); 
xlabel('Re(s)/s^-1'); ylabel('Im(s)/s^-1'), zlabel('|H(s)|/dB');  title('Betrag der Übertragungsfunktion in dB');
view([50,40]); hold off;

but=1;
while but==1
	figure(f1);
	[x,y,but]=ginput(1);
	if x>rmax, x=rmax; end;	if x<rmin, x=rmin; end;
	if y>imax, y=imax; end;	if y<imin, y=imin; end;
	set(l1,'Xdata',x,'Ydata',y); set(l2,'Xdata',x,'Ydata',-y);

	figure(f2); hold off;
	den=poly([x+j*y x-j*y]); 
    home;disp(' '),disp('Übertragungsfunktion darstellen.'),disp(' ')
    disp('Geben Sie durch Drücken der linken Maustaste die Polpositionen ein.') 
    disp('Geben Sie die Polposition mit der rechten Maustaste ein, wenn Sie weiterfahren wollen.'),disp(' ')
    omega0=sqrt(den(3)); f0=omega0/(2*pi); feigen=abs(y)/(2*pi); zeta=den(2)/(2*omega0);
    disp(['Resonanzkreisfrequenz omega0= ',num2str(omega0),' s^-1'])
    disp(['Resonanzfrequenz          f0= ',num2str(f0),' Hz'])
    disp(['Eigenfrequenz         feigen= ',num2str(feigen),' Hz'])
    disp(['Dämpfungsfaktor         zeta= ',num2str(zeta)]), disp(' ')
    num=omega0^2; 
    for jj=1:nn; z(:,jj)=polyval(den,xx(:,jj)); end
    zz=20*log10(num./abs(z)); h=surf(rx,ix,zz); hold on;
    maxz=max(max(zz))+10; plot3([x x],[-y -y],[-40 maxz]); plot3([x x],[y y], [-40 maxz]);
    xlabel('Re(s)/s^-1'); ylabel('Im(s)/s^-1'), zlabel('|H(s)|/dB');  title('Betrag der Übertragungsfunktion in dB');
    view([50,40]); hold off;
end


% Amplitudengang aufgrund des PN-Diagramms berechnen und darstellen

close all, home
f1=figure; set(f1,'Units','normal','Position',[0.1 0.2 0.3 0.3])
rmax=0; rmin=-4; imax=+4; imin=-imax;
axis([rmin rmax imin imax]); hold on;
axis('square'), title('PN-Diagramm'); xlabel('Re(s)/s^-1'); ylabel('Im(s)/s^-1'); grid

disp(' '),disp('Amplitudengang darstellen.'),disp(' ')
disp('Geben Sie durch Drücken der linken Maustaste die Polpositionen ein.') 
disp('Geben Sie die Polposition mit der rechten Maustaste ein, wenn Sie weiterfahren wollen.'),disp(' ')

[x,y]=ginput(1);
if x>rmax, x=rmax, end; if x<rmin, x=rmin, end;
if y>imax, y=imax, end; if y<imin, y=imin, end;
l1=line('Xdata',x,'Ydata',y,'LineStyle','x','Color','y','EraseMode','xor');
l2=line('Xdata',x,'Ydata',-y,'LineStyle','x','Color','y','EraseMode','xor');

f2=figure; set(f2,'Units','normal','Position',[0.45 0.1 0.5 0.5])
den=poly([x+j*y x-j*y]);
omega0=sqrt(den(3)); f0=omega0/(2*pi); feigen=abs(y)/(2*pi); zeta=den(2)/(2*omega0);
disp(['Resonanzkreisfrequenz omega0= ',num2str(omega0),' s^-1'])
disp(['Resonanzfrequenz          f0= ',num2str(f0),' Hz'])
disp(['Eigenfrequenz         feigen= ',num2str(feigen),' Hz'])
disp(['Dämpfungsfaktor         zeta= ',num2str(zeta)])
num=omega0^2; 
omega=0:0.01:imax; H=freqs(num,den,omega); HindB=20*log10(abs(H));
plot(omega,HindB); xlabel('omega/s^-1'); ylabel('|H(jomega)|/dB');  title('Amplitudengang in dB');
hold off;

but=1;
while but==1
	figure(f1);
	[x,y,but]=ginput(1);
	if x>rmax, x=rmax; end;	if x<rmin, x=rmin; end;
	if y>imax, y=imax; end;	if y<imin, y=imin; end;
	set(l1,'Xdata',x,'Ydata',y); set(l2,'Xdata',x,'Ydata',-y);

	figure(f2); hold off;
	den=poly([x+j*y x-j*y]); 
    omega0=sqrt(den(3)); f0=omega0/(2*pi); feigen=abs(y)/(2*pi); zeta=den(2)/(2*omega0);
    home;disp(' '),disp('Amplitudengang darstellen.'),disp(' ')
    disp('Geben Sie durch Drücken der linken Maustaste die Polpositionen ein.') 
    disp('Geben Sie die Polposition mit der rechten Maustaste ein, wenn Sie das Programm beenden wollen.'),disp(' ')
    disp(['Resonanzkreisfrequenz omega0= ',num2str(omega0),' s^-1'])
    disp(['Resonanzfrequenz          f0= ',num2str(f0),' Hz'])
    disp(['Eigenfrequenz         feigen= ',num2str(feigen),' Hz'])
    disp(['Dämpfungsfaktor         zeta= ',num2str(zeta)]), disp(' ')
    num=omega0^2; 
    omega=0:0.01:imax; H=freqs(num,den,omega); HindB=20*log10(abs(H));
    plot(omega,HindB); xlabel('omega/s^-1'); ylabel('|H(jomega)|/dB');  title('Amplitudengang in dB');
    hold off;
end

disp('Ende')