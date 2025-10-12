function demod_betrag_dqpsk
% Betragsverlauf bei einem DQPSK-Signal
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% PRBS 9
p = [ 1 0 0 0 1 0 0 0 0 ];
m = length(p);
b = zeros( 1, 430 );
r = ones( 1, m );
for i = 1 : 430
    b(i) = r(end);
    r = mod( [ 0 r(1:end-1) ] + r(end) * p, 2 );
end

% Symbol-Alphabet fuer DQPSK
s_m = [ 1 1i -1i -1 ];

% Differenzsymbole bilden
b_s = reshape( b, 2, [] );
idx = b_s(1,:) + 2 * b_s(2,:);
d_sym_1 = s_m( idx + 1 );
d_sym_2 = d_sym_1 * exp( 0.25i * pi );

% absolute Symbole bilden
l_sym = length(d_sym_1) + 1;
sym_1 = ones( 1, l_sym );
sym_2 = ones( 1, l_sym );
for i = 1 : l_sym - 1
    sym_1(i+1) = sym_1(i) * d_sym_1(i);
    sym_2(i+1) = sym_2(i) * d_sym_2(i);
end

% Basisbandsignale bilden
h = root_raised_cosine_filter( 32, 4, 0.33 );
x_1 = conv( kron( sym_1, [ 4 0 0 0 ] ), h );
x_2 = conv( kron( sym_2, [ 4 0 0 0 ] ), h );

% Ueberabtastung von T/4 auf T/64
h_r = resampling_filter( 16 );
x_1 = conv( kron( x_1, [ 16 zeros(1,15) ] ), h_r );
x_2 = conv( kron( x_2, [ 16 zeros(1,15) ] ), h_r );

% Einschwingvorgang abschneiden
l_h = 16 * length(h) + length(h_r);
x_1 = x_1( l_h : end - l_h );
x_2 = x_2( l_h : end - l_h );

k = ( 1 : length(x_1) ) / 64;

figure(1);
plot(k,abs(x_1),'b-','Linewidth',1);
grid;
axis([0 200 0 1.6]);
xlabel('t / T_s');
ylabel('abs(x)');
title('Betrag eines DQPSK-Sendesignals');

figure(2);
plot(k,abs(x_2),'b-','Linewidth',1);
grid;
axis([0 200 0 1.6]);
xlabel('t / T_s');
ylabel('abs(x)');
title('Betrag eines pi/4-DQPSK-Sendesignals');
