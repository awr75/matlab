% M-File  Faltung
%
% Dieses M-File simuliert die Faltung eines Rechteckpulses mit einem
% kausalen Exponentialpuls

% -----------------------  22.01.2010 / DvG  [MGT03]  ----------------------------

clear, colordef black, close all

dt=0.001;
ctau = 1.5;
clen = 1.0;
cstep = 0.0051;

%	filter 
tau = floor(ctau/dt);
alpha = exp( - 1 /tau );
%num = (1-alpha);
num = 1/tau;
den = [ 1 -alpha ];
[h,s] = dimpulse(num,den);
h = h*tau;
hmax = max(h);
hmin = min(h);

%	input
x = zeros(size(h));
len = floor(clen/dt)+1;
x(1:len) = ones(1,len);
%x(len+1:2*len) = -1*ones(1,len);
xmax = max(x);
xpmax = max(abs(x))*max(abs(h));
xmax = max( [ xmax hmax ] );
xmin = min(x);
xpmin = -xpmax;
xmin = min( [ xmin hmin ] );

%	output
y = filter(num,den,x);
ymax = max(abs(y));
ymin = -ymax;

tmin = -tau;

tmax = max( [ 2*tau len ] );
t = tmin:1:tmax;
t = t*dt;
ctmax = max(t);
ctmin = min(t);
pad = zeros(1,-tmin);
xx = [ pad x(1:tmax+1)' ];
hh = [ pad h(1:tmax+1)' ];
hht = zeros(size(hh));
yy = [ pad y(1:tmax+1)' ];

cstart = -0.1;
start = floor(cstart/dt);
stop = tmax;
%stop = 0;

%	product of signal and time reversed impulse response
dd = start;
rr = 1:-tmin+1+dd;
hht(rr) = flipud( h(rr));
xp = xx.*hht;

%	set up input/impulse response plot
set(gcf,'Units','normal','Position',[0.4 0.1 0.5 0.5])
subplot(3,1,1)
l1(1) = line('Xdata',t,'Ydata',xx);
set(l1(1),'LineStyle','-');
set(l1(1),'Color','y');
set(l1(1),'EraseMode','none');
l1(2) = line('Xdata',t,'Ydata',hh);
set(l1(2),'LineStyle','-');
set(l1(2),'Color','c');
set(l1(2),'EraseMode','xor');
l1(3) = line('Xdata',t,'Ydata',zeros(size(hh)));
set(l1(3),'LineStyle','-');
set(l1(3),'Color','w');
set(l1(3),'EraseMode','none');
xxx = [ 0  ];
yyy = [ 0  ];
l1(4) = line('Xdata',xxx,'Ydata',yyy);
set(l1(4),'Marker','o');
set(l1(4),'Color','k');
set(l1(4),'EraseMode','xor');
xxx = [ 0  0 ];
yyy = [ 0  0 ];
l1(5) = line('Xdata',xxx,'Ydata',yyy);
set(l1(5),'LineStyle','-');
set(l1(5),'Color','k');
set(l1(5),'EraseMode','xor');
title('Gelb: x(tau), Cyan: h(tau)')
xlabel('tau/sec')
axis( [ ctmin ctmax xmin xmax ] );
hold on

%	set up product plot
subplot(3,1,2)
l2(1) = line('Xdata',t,'Ydata',zeros(size(xp)));
set(l2(1),'LineStyle','-');
set(l2(1),'Color','w');
set(l2(1),'EraseMode','xor');
hold on
f2 = fill(t,xp,'g');
set(f2,'EraseMode','xor');
xxx = [ 0  ];
yyy = [ 0  ];
l2(2) = line('Xdata',xxx,'Ydata',yyy);
set(l2(2),'LineStyle','o');
set(l2(2),'Color','k');
set(l2(2),'EraseMode','xor');
xxx = [ 0 0 ];
yyy = [ 0 0 ];
l2(3) = line('Xdata',xxx,'Ydata',yyy);
set(l2(3),'LineStyle','-');
set(l2(3),'Color','k');
set(l2(3),'EraseMode','xor');
axis( [ ctmin ctmax xpmin xpmax ] ); 
title('Mangenta: x(tau)h(t-tau),  Grüne Fläche: Faltung y(t)')
xlabel('tau/sec')


%	set up output plot
subplot(3,1,3)
l3(1) = line('Xdata',t,'Ydata',zeros(size(xx)));
set(l3(1),'LineStyle','-');
set(l3(1),'Color','w');
set(l3(1),'EraseMode','xor');
xxx = [ 0  ];
yyy = [ 0  ];
l3(2) = line('Xdata',xxx,'Ydata',yyy);
set(l3(2),'LineStyle','o');
set(l3(2),'Color','k');
set(l3(2),'EraseMode','xor');
xxx = [ 0 0 ];
yyy = [ 0 0 ];
l3(3) = line('Xdata',xxx,'Ydata',yyy);
set(l3(3),'LineStyle','-');
set(l3(3),'Color','k');
set(l3(3),'EraseMode','xor');
axis( [ ctmin ctmax ymin ymax ] ); 
xlabel('t/sec')
title('Faltung y(t)')
hold on

disp(' ')
fprintf(1,'Faltung eines Rechteckpulses x(t) mit einem kausalen Exponentialpuls h(t)\n\n')
fprintf(1,'Return-Taste drücken um weiterzufahren\n\n')
pause

%	starting point for plots
subplot(3,1,1)
title('Gelb: x(tau), Cyan: h(t-tau)')
set(l1(2),'Xdata',t,'Ydata',hht);
xxx = start*dt;
yyy = 0;
set(l1(4),'Xdata',xxx,'Ydata',yyy,'Color','r');
xxx = [ start start ]*dt;
yyy = [ xx(start+1-tmin) xmin ];
set(l1(5),'Xdata',xxx,'Ydata',yyy,'Color','k');

pause

step = floor(cstep/dt);
for dd = start:step:stop,

rr = 1:-tmin+1+dd;
hht(rr) = flipud( h(rr));

%	time reference
subplot(3,1,1)
xxx = dd*dt;
yyy = 0;
set(l1(4),'Xdata',xxx,'Ydata',yyy);
xxx = [ dd dd ]*dt;
yyy = [ xx(dd+1-tmin) xmin ];
set(l1(5),'Xdata',xxx,'Ydata',yyy,'Color','r');
subplot(3,1,2)
xxx = dd*dt;
yyy = 0;
set(l2(2),'Xdata',xxx,'Ydata',yyy,'Color','k');
xxx = [ dd dd ]*dt;
yyy = [ xpmin xpmax ];
set(l2(3),'Xdata',xxx,'Ydata',yyy,'Color','r');
subplot(3,1,3)
xxx = dd*dt;
yyy = yy(-tmin+1+dd);
set(l3(2),'Xdata',xxx,'Ydata',yyy,'Color','g');
xxx = [ dd dd ]*dt;
yyy = [ ymax yy(-tmin+1+dd) ];
set(l3(3),'Xdata',xxx,'Ydata',yyy,'Color','r');

%	slide impulse response
subplot(3,1,1)
set(l1(2),'Xdata',t,'Ydata',hht);
%	product & its integral 
subplot(3,1,2)
xp = xx.*hht;
set(l2(1),'Xdata',t,'Ydata',xp);
set(f2,'Xdata',t,'Ydata',xp);
%	output
subplot(3,1,3)
set(l3(1),'Xdata',t(rr),'Ydata',yy(rr));

%pause (1)

end