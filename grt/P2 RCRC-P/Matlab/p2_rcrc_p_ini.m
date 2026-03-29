%% model

% parameters
R1 = 4.7e3;  % Ohm
R2 = R1;
C1 = 470e-9; % F
C2 = C1;

% rcrc
a = R1*R2*C1*C2;
b = R1*C1 + R1*C2 + R2*C2;

% transfer function
s = tf('s');
Grcrc_mod = 1 / (a*s^2 + b*s + 1);
%Grcrc_mod = tf(1,[a b 1])

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


%% step response comparison

% step response measurement
% - unit step starting at 0.05 sec
% - measurement time 0.10 sec
load Step_Gs.mat % save data_00 data

time = data.time;
u  = data.signals(1).values;
y = data.signals(2).values;

% simulate the transfer function with input u forward in time
y_mod = lsim(Grcrc_mod, u, time);

figure(2)
subplot(211)
plot(time, u), grid on
ylabel('u [V]'), xlabel('Time [s]')
xlim([0.04 0.1])
subplot(212)
plot(time, [y, y_mod]), grid on
ylabel('y [V]'), xlabel('Time [s]')
legend('Messung', 'Simulation', 'Location', 'best')
xlim([0.04 0.1])
title('ungeregelt')


%% frequency response comparison

% frequency response measurement
% - 0.1 Hz - 10 kHz, 10 sec
% - magnitude 1V
load FRF_Gs.mat

figure(3)
bode(Gs, Grcrc_mod), grid on
legend('Measurement', 'Simulation', 'Location', 'best')


%% closed-loop dc gain

Kp_vec = (0:0.01:10.0).';
Kw_vec = Kp_vec ./ (Kp_vec + 1);

figure(4)
plot(Kp_vec, Kw_vec), grid on
ylabel('DC-Gain'), xlabel('Kp')


%% closed-loop poles

c = Kp_vec + 1;
pw1 = -b/(2*a) + sqrt(b^2 - 4*a*c) / (2*a);
pw2 = -b/(2*a) - sqrt(b^2 - 4*a*c) / (2*a);

figure(5)
plot(real([pw1, pw2]), imag([pw1, pw2])), grid on
ylabel('Imaginary Axis'), xlabel('Real Axis')


%% Kp so that the closed-loop has double real poles

% double real pol: b^2 - 4*a*c = 0
Kp = b^2 / (4*a) - 1

Kw = Kp/(Kp + 1)
pw = -b/(2*a)
Tw = 1/-pw

Gw_mod = minreal(Kp / (a*s^2 + b*s + (Kp + 1)))
Gw_mod = minreal(Kw * pw^2 / (s - pw)^2)
Gw_mod = minreal(Kw * 1 / (Tw*s + 1)^2)


%% closed-loop step response

% step response measurement
% - unit step starting at 0.05 sec
% - measurement time 0.10 sec
load Step_Gw.mat

time = data.time;
u = data.signals(1).values;
w = data.signals(2).values(:,1);
y = data.signals(2).values(:,2);

figure(6)
subplot(211)
plot(time, u), grid on
ylabel('u [V]'), xlabel('Time [s]')
xlim([0.04 0.1])
subplot(212)
plot(time, [w,y]), grid on
ylabel('w,y [V]'), xlabel('Time [s]')
legend('Soll','Ist', 'Location', 'best')
xlim([0.04 0.1])


%% closed-loop frequency response

% frequency response measurement
% - 0.1 Hz - 10 kHz, 10 sec
% - magnitude 1V
load FRF_Gw.mat

figure(7)
bode(Gw, Gw_mod), grid on
legend('Messung', 'Simulation', 'Location', 'best')


%% Vergleich Kw = Gw(0) = 5/9
figure(8)
step(Grcrc_mod,Gw_mod,0.2), grid on
legend('ungeregelt','geregelt Kp=5/4')

figure(9)
bode(Grcrc_mod,Gw_mod), grid on
legend('ungeregelt','geregelt Kp=5/4')

%% Vergleich Kw = Gw(0) = 1 
figure(10)
step(Grcrc_mod,Gw_mod*9/5,0.2), grid on
legend('ungeregelt','geregelt Kp=5/4')

figure(11)
bode(Grcrc_mod,Gw_mod*9/5), grid on
legend('ungeregelt','geregelt Kp=5/4')
