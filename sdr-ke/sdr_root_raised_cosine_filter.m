function sdr_root_raised_cosine_filter
% Berechnung von Root Raised Cosine Filtern
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

g_025 = root_raised_cosine_filter(47,4,0.25);
[G,f] = freqz(g_025,1,1024,4);
G_025 = 20 * log10(abs(G));

g_033 = root_raised_cosine_filter(32,4,1/3);
G     = freqz(g_033,1,1024,4);
G_033 = 20 * log10(abs(G));

g_050 = root_raised_cosine_filter(23,4,0.5);
G     = freqz(g_050,1,1024,4);
G_050 = 20 * log10(abs(G));

figure(1);
plot(0:length(g_025)-1,g_025,'bs','Linewidth',3,'Markersize',3);
grid;
axis([0 length(g_025)-1 -0.1 0.3]);
title('Root Raised Cosine Filter r = 0.25');

figure(2);
plot(0:length(g_033)-1,g_033,'rs','Linewidth',3,'Markersize',3);
grid;
axis([0 length(g_033)-1 -0.1 0.3]);
title('Root Raised Cosine Filter r = 0.33');

figure(3);
plot(0:length(g_050)-1,g_050,'s','Color',[0 0.5 0],'Linewidth',3,'Markersize',3);
grid;
axis([0 length(g_050)-1 -0.1 0.3]);
title('Root Raised Cosine Filter r = 0.5');

figure(4);
plot(f,G_025,'b-','Linewidth',1);
hold on;
plot(f,G_033,'r-','Linewidth',1);
plot(f,G_050,'-','Color',[0 0.5 0],'Linewidth',1);
hold off;
grid;
axis([0 2 -80 10]);
title('Root Raised Cosine Filter');
legend('r = 0.25','r = 0.33','r = 0.5');
