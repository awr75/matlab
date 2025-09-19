% M-File  FourierReihe
%
% Dieses M-File approximiert einen periodischen Rechteck mithilfe der
% Fourier-Reihe

% -----------------------  20.11.2009 / DvG  [MGT03]  ---------------


close, home, clear, colordef black

disp(' '),disp(' ')
disp('Approximation eines Rechtecks mithilfe der Fourier-Reihe') 
disp('--------------------------------------------------------')
disp(' '),disp(' ')

%	square wave
N = 1024;
t = [ 0:N ]/N;
x = ones(1,N)*(-1);
x(1:N/2) = ones(1,N/2);
x(N+1) = x(1);

%	harmonics & approximations
X = fft(x,N);				%approx Fourier coefficients
xp = zeros(15,N+1);			%harmonics
xt = zeros(15,N+1);			%approximations
for jj = 1:2:13;
%	harmonic number jj
	Xp = zeros(1,N);
	Xp(jj+1) = X(jj+1);
	Xp(N-jj+1) = X(N-jj+1);
	xp(jj,1:N) = ifft(Xp,N);
	if jj > 1
		xt(jj,:) = xt(jj-2,:) + real(xp(jj,:));
	else
		xt(jj,:) = real(xp(jj,:));
	end
end
xt(:,N+1) = xt(:,1);
xp(:,N+1) = xp(:,1);


%	set up axis
subplot(2,1,1)
%	waveform
l1(1) = line('Xdata',t,'Ydata',x);
set(l1(1),'LineStyle','-','Color','w','Erasemode','none');
%	Fourier approximation
l1(2) = line('Xdata',t,'Ydata',xt(2,:));
set(l1(2),'LineStyle','-','Color','y','Erasemode','xor');
%	Fourier approximation - additional harmonic
l1(3) = line('Xdata',t,'Ydata',xt(2,:));
set(l1(3),'LineStyle','-','Color','y','Erasemode','none');
l1(4) = line('Xdata',[t(1) t(1)] ,'Ydata',[ xt(2,1) -1.5 ]);
set(l1(4),'LineStyle','--','Color','b','Erasemode','xor');

xlabel ('Zeit in Sekunden');
title('Weiss: Rechteck, Gelb: Approximation durch Fourier-Reihe')
axis( [ 0 1 -1.5 1.5 ] );

subplot(2,1,2)
l2(1) = line('Xdata',t,'Ydata',xp(1,:));
set(l2(1),'LineStyle','-','Color','g','Erasemode','xor');
l2(2) = line('Xdata',[t(1) t(1)] ,'Ydata',[ xp(2,1) 1.5 ]);
set(l2(2),'LineStyle','--','Color','b','Erasemode','xor');
xlabel ('Zeit in Sekunden')
axis( [ 0 1 -1.5 1.5 ])

set(gcf,'Units','normal','Position',[0.4 0.1 0.5 0.5])


for jj = 1:2:7
%jj = 3;
	set(l1(1),'Xdata',t,'Ydata',x,'Erasemode','none');
	if jj > 1
		set(l1(2),'Xdata',t,'Ydata',xt(jj-2,:),'Erasemode','none');
		else
		set(l1(2),'Xdata',t,'Ydata',xt(2,:),'Erasemode','none');
	end	
	set(l2(1),'Xdata',t,'Ydata',xp(jj,:),'Erasemode','none');	
    title ([num2str(jj),'.Harmonische'])	
	fprintf(1,'%d. Harmonische durch Drücken der Enter-Taste hinzufügen \n',jj)
	pause

	yy1 = xt(jj,:);
	if jj > 1
		yy1a = xt(jj-2,:);
		else
		yy1a = xt(2,:);	
	end
	yy2 = real(xp(jj,:));
	
	Nstep = 32;
	rr = 1:Nstep+1;
	set(l1(2),'Xdata',t(rr),'Ydata',yy1a(rr),'Erasemode','background');
	set(l2(1),'Xdata',t(rr),'Ydata',yy2(rr),'Erasemode','background');
	set(l2(2),'Xdata',t(rr),'Ydata',yy2(rr),'Erasemode','background');
	drawnow
	for ii =1:Nstep:N-Nstep
%		timer
		t0 = clock;
		te = 0;
		
		rr = ii:ii+Nstep;
		set(l1(2),'Xdata',t(rr+Nstep),'Ydata',yy1a(rr+Nstep),'Erasemode','background');
		set(l1(3),'Xdata',t(rr),'Ydata',yy1(rr));
		set(l1(4),'Xdata',[ t(rr(Nstep+1)) t(rr(Nstep+1)) ], 'Ydata', [ yy1(rr(Nstep+1)) -1.5] );
		set(l2(1),'Xdata',t(rr+Nstep),'Ydata',yy2(rr+Nstep),'Erasemode','background');
		set(l2(2),'Xdata',[ t(rr(Nstep+1)) t(rr(Nstep+1)) ], 'Ydata', [ yy2(rr(Nstep+1)) 1.5] );
%	 	constant frame rate
		while te < 0.25
			te = (clock - t0) * [0 0 86400 3600 60 1]';
		end

	end
	set(l1(4),'Xdata',[t(1)+0.005 t(1)+0.005],'Ydata',[ xt(2,1) -1.5 ]);
	set(l2(2),'Xdata',[t(1)+0.005 t(1)+0.005] , 'Ydata',[ xp(2,1) 1.5 ]);
	
	set(l1(1),'Xdata',t,'Ydata',x,'Erasemode','xor');
	set(l1(2),'Xdata',t,'Ydata',xt(jj,:),'Erasemode','none');
	set(l1(1),'Xdata',t,'Ydata',x,'Erasemode','xor');
	set(l1(2),'Xdata',t,'Ydata',xt(jj,:),'Erasemode','none');
end
set(l2(1),'Erasemode','background')
drawnow