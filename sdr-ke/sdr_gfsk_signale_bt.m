function sdr_gfsk_signale_bt
% GFSK-Signale mit h = 1 und BT = 0.5 / 1 / 10
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Symboldauer
T_s = 1;

% Abtastrate
f_a = 40 / T_s;

% Modulationsindex
h = 0.5;

% Shift
f_shift = h / T_s;

% BT-Produkt
BT = [ 0.5 1 100 ];

% Binaersymbole als PRBS erzeugen
p = [ 1 1 0 0 1 0 1 0 0 0 0 0 ];
m = length(p);
M = 2^m - 1;
s = zeros( 1, M );
reg = ones( 1, m );
for i = 1 : M
    s(i) = 2 * reg(end) - 1;
    reg  = mod( [ 0 reg(1:end-1) ] + reg(end) * p, 2 );
end

% Rechteck-Filter
s_r = kron( s, ones( 1, f_a * T_s ) );

r = [];
for i = 1 : length(BT);

    % Gauss-Filter
    n = ceil( 0.5 * f_a * T_s / BT(i) );
    t_g = ( -n : n ) / f_a;
    B_g = BT(i) / T_s;
    g_g = sqrt( 2 * pi / log(2) ) * B_g / f_a * ...
          exp( -2 * ( pi * B_g * t_g ).^2 / log(2) );
    g_g = g_g / sum(g_g);

    % Gauss-Filterung
    s_fm = conv( s_r, g_g );
    
    % Signalabschnitt
    off = n + 54.5 * f_a * T_s;
    r(i).s_fm = s_fm( off : off + 20 * f_a * T_s );

    % Basisbandsignal
    x = exp( 1i * pi * f_shift / f_a * cumsum( s_fm ) );
    
    % Spektrum
    [ r(i).p, r(i).f_norm ] = power_spectrum_density( x, f_a * T_s, 16384);
    
end

t_norm = ( 0 : length(r(1).s_fm) - 1 ) / ( f_a * T_s );

figure(1);
plot(r(1).f_norm,r(1).p,'b-','Linewidth',1);
hold on;
plot(r(2).f_norm,r(2).p,'r-','Linewidth',1);
plot(r(3).f_norm,r(3).p,'-','Color',[0 0.5 0],'Linewidth',1);
hold off;
grid;
axis([-4 4 -100 -10]);
xlabel('T_s * f');
ylabel('S_x [dB]');
title('Spektren');
legend('BT = 0.5','BT = 1','BT = inf');

figure(2);
plot(t_norm,r(1).s_fm,'b-','Linewidth',1);
hold on;
plot(t_norm,r(2).s_fm,'r-','Linewidth',1);
plot(t_norm,r(3).s_fm,'-','Color',[0 0.5 0],'Linewidth',1);
hold off;
grid;
axis([min(t_norm) max(t_norm) -1.2 1.2]);
xlabel('t / T_s');
title('Signalausschnitte');
legend('BT = 0.5','BT = 1','BT = inf');
