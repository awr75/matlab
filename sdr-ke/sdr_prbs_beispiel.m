function sdr_prbs_beispiel
% Beispiel zur Erzeugung von Pseudo-Zufallsfolgen (PRBS)
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Polynom x^6 + x^5 + 1 ohne konstanten Term
p = [ 1 1 0 0 0 0 ];
m = length(p);
M = 2^m - 1;

% Vektor fuer eine Periode anlegen
b_r_period = zeros(1,M);

% Register initialisieren
reg = ones(1,m);

% Periode berechnen
for i = 1 : M
    b_r_period(i) = reg(end);
    reg = mod( [ 0 reg(1:end-1) ] + reg(end) * p, 2 );
end

% Autokorrelation berechnen
d = -M+1 : M-1;
r = zeros( 1, 2 * M - 1 );
for i = 1 : 2 * M - 1
    r(i) = sum( b_r_period .* circshift( b_r_period, [ 0 d(i) ] ) );
end

figure(1);
plot(d,r,'bs','Linewidth',3,'Markersize',2);
grid;
axis([ min(d) max(d) 2^(m-2)-1 2^(m-1)+1 ]);
xlabel('Verschiebung d');
ylabel('AKF');
title('Autokorrelationsfunktion einer PRBS');
