function demod_gfsk_machted_filter
% Matched Filter fuer die Praeambel-Korrelation
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Bits der Praeambel
p_p = [ 1 0 1 0 0 ];
m_p = length(p_p);
M_p = 2^m_p - 1;
b_p = zeros( 1, M_p + 1 );
reg = ones( 1, m_p );
for i = 1 : M_p
    b_p(i) = reg(end);
    reg = mod( [ 0 reg(1:end-1) ] + reg(end) * p_p, 2 );
end
% Symbole der Praeambel
s_p = 2 * b_p - 1;
% Matched Filter
h_m = fliplr( kron( s_p, [ 1 zeros(1,7) ] ) );
h_m = h_m( 8 : end );
n_m = 0 : 8 * M_p;

figure(1);
plot(0:M_p,b_p,'bs','Linewidth',3,'Markersize',2);
grid;
set(gca,'XTick',0:5:M_p);
set(gca,'YTick',[0 1]);
axis([-1 M_p+1 -0.2 1.2]);
set(gca,'PlotBoxAspectRatio',[1 0.2 1]);
title('Bits der Praeambel');

figure(2);
plot(0:M_p,s_p,'bs','Linewidth',3,'Markersize',2);
grid;
set(gca,'XTick',0:5:M_p);
set(gca,'YTick',[-1 0 1]);
axis([-1 M_p+1 -1.2 1.2]);
set(gca,'PlotBoxAspectRatio',[1 0.4 1]);
title('Symbole der Praeambel');

figure(3);
plot(n_m,h_m,'b.');
set(gca,'XDir','Reverse');
grid;
set(gca,'XTick',8*(0:5:M_p));
set(gca,'YTick',[-1 0 1]);
axis([-8 8*M_p+8 -1.2 1.2]);
set(gca,'PlotBoxAspectRatio',[1 0.4 1]);
title('Koeffizienten des langen Matched Filters');
