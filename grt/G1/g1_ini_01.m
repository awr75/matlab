clc, clear variables

% T-Domain Identification Param
%n=1
c1 = 0.63;

mu1 = 0.046;
a1_10 = 0.11;
a1_50 = 0.7;
a1_90 = 2.3;
alpha1 = 2.2;

%n=2
mu2 = 0.14;
a2_10 = 0.53;
a2_50 = 1.7;
a2_90 = 3.9;
alpha2 = 3.4;

%n=3
mu3 = 0.21;
a3_10 = 1.1;
a3_50 = 2.7;
a3_90 = 5.3;
alpha3 = 4.2;

% Start Time, Sample Time
t0 = 0.05
Ts = 5e-4;
K0 = 2;

% Measurement
load g1_step_data_01.mat % save step_meas_00 data_meas

t = g1_step_data_01.time;
u = g1_step_data_01.signals(1).values;
y1 = g1_step_data_01.signals(2).values;
y2 = g1_step_data_01.signals(3).values;
y3 = g1_step_data_01.signals(4).values;
y4 = g1_step_data_01.signals(5).values;

load g1_G1_data_01.mat
load g1_G2_data_01.mat
load g1_G23_data_01.mat

f = G1.Frequency;
s = tf('s');

% Start Idx
idx0 = find(t==t0)
abs(t(idx0) - t0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% G1 Time Domain
figure(1)
plot(t, u), grid on, hold on
plot(t, y1), hold off
xlabel('Time [s]')
ylabel('Voltage [V]')
legend('u', 'y1', ...
    'Location', 'best')
xlim([0.045 0.055])

figure(2)
plot(t, y1 - u)
xlabel('Time [s]')
ylabel('Voltage [V]')
legend('y1-u', ...
    'Location', 'best')
xlim([0.0495 0.054])

t1 = 0.0525
Tt = t1 - t0

idx1 = find(t==t1)
abs(t(idx1) - t1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% G2 Time Domain
figure(3)
plot(t, u), grid on, hold on
plot(t, y1)
plot(t, y2), hold off
xlabel('Time [s]')
ylabel('Voltage [V]')
legend('u', 'y1', 'y2', ...
    'Location', 'best')
xlim([0.045 0.3])

K2 = y2(end) / K0

[val idx2_10] = min(abs(y2/y2(end) - 0.1));
t2_10 = t(idx2_10) - t1

[val idx2_50] = min(abs(y2/y2(end) - 0.5));
t2_50 = t(idx2_50) - t1

[val idx2_90] = min(abs(y2/y2(end) - 0.9));
t2_90 = t(idx2_90) - t1

mu2 = t2_10/t2_90
n2 = 1
T2 = (t2_10/a1_10 + t2_50/a1_50 + t2_90/a1_90) / 3

[val idx2_63] = min(abs(y2/y2(end) - c1));
T2_test = t(idx2_63) - t1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% G23 = G2*G3 Time Domain

figure(4)
plot(t, u), grid on, hold on
plot(t, y1)
plot(t, y3), hold off
xlabel('Time [s]')
ylabel('Voltage [V]')
legend('u', 'y1', 'y3', ...
    'Location', 'best')
xlim([0.045 0.3])

K23 = y3(end) / K0

[val idx23_10] = min(abs(y3/y3(end) - 0.1));
t23_10 = t(idx23_10) - t1

[val idx23_50] = min(abs(y3/y3(end) - 0.5));
t23_50 = t(idx23_50) - t1

[val idx23_90] = min(abs(y3/y3(end) - 0.9));
t23_90 = t(idx23_90) - t1

mu23 = t23_10/t23_90
n23 = 2
T23 = (t23_10/a2_10 + t23_50/a2_50 + t23_90/a2_90) / 3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% G234 = G2*G3*G4 Time Domain

figure(5)
plot(t, u), grid on, hold on
plot(t, y1)
plot(t, y4), hold off
xlabel('Time [s]')
ylabel('Voltage [V]')
legend('u', 'y1', 'y4', ...
    'Location', 'best')
xlim([0.045 0.3])

K234 = y4(end) / K0

[val idx234_10] = min(abs(y4/y4(end) - 0.1));
t234_10 = t(idx234_10) - t1

[val idx234_50] = min(abs(y4/y4(end) - 0.5));
t234_50 = t(idx234_50) - t1

[val idx234_90] = min(abs(y4/y4(end) - 0.9));
t234_90 = t(idx234_90) - t1

mu234 = t234_10/t234_90
n234 = 3
T234 = (t234_10/a3_10 + t234_50/a3_50 + t234_90/a3_90) / 3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% G1 Frequency Domain
figure(6)
plot(f, unwrap(angle(squeeze(G1.ResponseData)))), grid on, hold on
plot(f, -2*pi*f*Tt), hold off
xlabel('Frequency [Hz]')
ylabel('Phase [rad]')
legend('G1', '-2*pi*f*Tt')

G1fit = frd(exp(-2*pi*f*Tt*i), 2*pi*f);

figure(7)
bode(G1, G1fit)
legend('G1', 'exp(-j*2*pi*f*Tt)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% G2 Frequency Domain
[g_max2, f_peak2] = getPeakGain(G2)
w2 = bandwidth(G2, -3)
1/w2
T2


G2fit = g_max2 / (s/w2 + 1);

figure(8)
bode(G2, G2fit)
legend('G2')

%[mag, phase] = bode(sys, 100)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% G23=G2*G3 Frequency Domain
[g_max23, f_peak23] = getPeakGain(G23)
w23 = bandwidth(G23, -6)
1/w23
T23

G23fit = g_max23 / (s/w23 + 1)^2;

figure(9)
bode(G23, G23fit)
legend('G23')

% %% model

% 
% % parameters
% R = 4.7e3;  % Ohm
% C = 470e-9; % F
% 
% 
% %% step response measurement
% 
% % step response measurement
% % - unit step starting at 0.05 sec
% % - measurement time 0.10 sec
% load step_meas_00.mat % save step_meas_00 data_meas
% 
% figure(1)
% plot(data_meas.time-0.05, data_meas.signals(1).values), grid on, hold on
% plot(data_meas.time-0.05, data_meas.signals(2).values), hold off
% xlim([-0.01,0.02])
% xlabel('Time (sec)')
% ylabel('Voltage (V)')
% legend('Input', 'Capacitor Measurement', ...
%     'Location', 'best')
% 
% 
% %% step response comparison
% sim('p1_rc_sim')
% % step response simulation (Simulink)
% %load step_sim_00.mat % save step_sim_00 data_sim
% 
% figure(2)
% plot(data_meas.time, data_meas.signals(1).values), grid on, hold on
% plot(data_meas.time, data_meas.signals(2).values)
% plot(data_sim.time, data_sim.signals(2).values), hold off
% xlabel('Time (sec)')
% ylabel('Voltage (V)')
% legend('Input', 'Capacitor Simulation', ...
%     'Capacitor Measurement', ...
%     'Location', 'best')
% xlim([0.045 0.07])
% 
% 
% %% model as tf-object and step function
% 
% % transfer function
% s = tf('s');
% Grc_mod = 1 / (R*C*s + 1);
% figure(2)
% step(Grc_mod), grid on
% 
% t = linspace(0,0.02,1000)';
% 
% figure(3)
% step(Grc_mod,t), grid on
% 
% 
% %% frequency response measurments
% 
% % time constant
% T = R*C;
% % cutoff frequency
% wg = 1/T;
% 
% % excitation
% w0 = [1, wg, 1e3];
% uE_hat = [1.0, 2.0, 3.0];
% 
% % frequency in hz
% f0 = w0 / (2*pi)
% T_p = 1 ./ f0
% 
% % system answer
% uC_hat = [1.000, 1.403, 1.244]; % <- fill values here
% 
% % magnitude |G(w)|
% G_mag = uC_hat ./ uE_hat
% G_mag_db = db(G_mag)
% 
% % phase angle(G(w)))
% dT = [0.0, 1.728e-3, 1.192e-3]; % <- fill values here
% dT_ms = dT * 1e3
% G_pha = -dT .* w0;
% G_pha_Deg = G_pha * 180/pi
% 
% % G(w) = |G(w)| * exp(i * angle(G(w)))
% G0 = G_mag .* exp(1i * G_pha)
% 
% % frequency response model
% w = logspace(-1, 5, 1e3)';
% Grc_mod_freq = 1 ./ (R*C*1i*w + 1);
% 
% figure(4)
% subplot(211)
% semilogx(w, 20 * log10(abs( Grc_mod_freq ))), grid on, hold on
% semilogx(w0, 20 * log10(G_mag), 'rx'), hold off
% %set(gca, 'XScale', 'log')
% ylabel('Magnitude (dB)')
% % axis([2*pi*0.1, 2*pi*1e4, -60 20])
% subplot(212)
% semilogx(w, 180/pi * (angle( Grc_mod_freq ))), grid on, hold on
% semilogx(w0, 180/pi * G_pha, 'rx'), hold off
% % set(gca, 'XScale', 'log')
% ylabel('Phase (deg)'), xlabel('Frequency (rad/s)')
% % axis([2*pi*0.1, 2*pi*1e4, -95, 5])
% 
% 
% %% model as tf-object and bode function
% 
% load G_00.mat % save G_00 G
% 
% % Grc_mod_with_delay = Grc_mod;
% % Grc_mod_with_delay.InputDelay = 50e-6 / 2; % Ts / 2
% 
% figure(5)
% bode(G, Grc_mod), grid on
% legend('Measurement', ...
%     'Model', ...
%     'Location', 'best')
% % bode(G, Grc_mod, Grc_mod_with_delay)
% % legend('Measurement', ...
% %     'Model', ...
% %     'Model with Deadtime', ...
% %     'Location', 'best')
