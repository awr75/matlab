function sdr_praeambel
% Aperiodische Autokorrelation von Praeambeln
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Chu Sequence (Polyphasen-Symbole)
N = 31;
n = 0 : N - 1;
s_p_chu = exp( 1i * pi * n .* ( n + 1 ) / N );
% aperiodische Autokorrelation
R_sp_sp_chu = conv( s_p_chu , conj( fliplr(s_p_chu) ) );

% PRBS x^5 + x^3 + 1 (BPSK-Symbole)
p = [ 1 0 1 0 0 ];
m = length(p);
M = 2^m - 1;
s_p_prbs = zeros( 1, M );
reg = ones( 1, m );
for i = 1 : M
    s_p_prbs(i) = 1 - 2 * reg(end);
    reg = mod( [ 0 reg(1:end-1) ] + reg(end) * p, 2 );
end
% aperiodische Autokorrelation
R_sp_sp_prbs = conv( s_p_prbs , conj( fliplr(s_p_prbs) ) );

d = - N + 1 : N - 1;

figure(1);
plot(d,abs(R_sp_sp_chu),'bs','Linewidth',3,'Markersize',2);
grid;
axis([min(d) max(d) 0 40]);
xlabel('Verschiebung d');
ylabel('Betrag der AKF');
title('Autokorrelationsfunktion der Chu Sequence');

figure(2);
plot(d,abs(R_sp_sp_prbs),'bs','Linewidth',3,'Markersize',2);
grid;
axis([min(d) max(d) 0 40]);
xlabel('Verschiebung d');
ylabel('Betrag der AKF');
title('Autokorrelationsfunktion der BPSK-modulierten PRBS');
