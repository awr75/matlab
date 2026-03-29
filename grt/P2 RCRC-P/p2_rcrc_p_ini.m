clc, clear variables
%% model

% parameters
R1 = 4.7e3;  % Ohm
R2 = R1;
C1 = 470e-9; % F
C2 = C1;

% rcrc
a = R1*R2*C1*C2
b = R1*C1 + R1*C2 + R2*C2

% transfer function
s = tf('s');
Grcrc_mod = 1 / (a*s^2 + b*s + 1);

% poles
p1 = -b/(2*a) + sqrt(b^2 - 4*a)/(2*a)
p2 = -b/(2*a) - sqrt(b^2 - 4*a)/(2*a)

% matlab functions
K = dcgain(Grcrc_mod) % dc-gain <-> Statische Verstärkung
z = zero(Grcrc_mod)   % zeros   <-> Nullstellen
p = pole(Grcrc_mod)   % poles   <-> Polstellen

% pole-zero-form 
Gpz_mod = p1 * p2 / ((s - p1) * (s - p2))
Gpz_mod = zpk([], [p1, p2], p1*p2)
Gpz_mod = zpk(Grcrc_mod)

% time-constant-form
T1 = 1/-p1 % <-> p1 = 1/-T1
T2 = 1/-p2 % <-> p2 = 1/-T2
Gpt1_1 = 1 / (T1*s + 1);
Gpt1_2 = 1 / (T2*s + 1);
Gpt2 = Gpt1_1 * Gpt1_2
Gpz_mod.DisplayFormat = 'tc'

figure(1)
bode(Gpt1_1, Gpt1_2, Gpt2), grid on
legend('Location', 'best')
