clc, clear variables
%% Saves'
% save step_meas_00 data_meas
% save chirp_meas_00 G_meas
%% model

% parameters
km = 12.9;   % current-force-constant (N/A) (datasheet)
ru = 6.8e-3; % radius of unbalanced mass (m)
mu = 22e-3;  % unbalanced mass (kg)


 %% time-domain system identification

% step response measurement
% - 0.5 A step starting at 0.1 sec
% - measurement time 1.0 sec
load step_meas_00.mat % save step_meas_00 data_meas

figure(1)
sgtitle('Sprungantwort VoiceCoil')
subplot(211)
plot(data_meas.time, data_meas.signals(1).values), grid on
ylabel('Input Current (A)'), xlabel('Time (sec)')
subplot(212)
plot(data_meas.time, data_meas.signals(2).values), grid on
ylabel('Output Position (mm)'), xlabel('Time (sec)')

%% Aufgabe 1
Udach=0.5;
Ydach=5.135;
Ks =  Ydach/Udach;
Tp = 0.2787-0.16095;
d1 = abs(8.66-Ydach);
d2 = abs(2.4-Ydach);
theta = log(d1 / d2);
D = 1 / sqrt(1 + pi^2/theta^2);
wd = 2*pi / Tp;
w0 = wd / sqrt(1 - D^2);

%% Aufgabe 2
load chirp_meas_00.mat
s = tf('s');
Gvc_mod1 = Ks * w0^2 / (s^2 + 2*D*w0*s + w0^2);

figure (2)
StepSim=lsim(Gvc_mod1,data_meas.signals(1).values,data_meas.time);
plot(data_meas.time, data_meas.signals(2).values,data_meas.time,StepSim), grid on
title('Comparison Simulation to Measurement')
legend('Measurement', 'Simulation')
ylabel('Output Position (mm)'), xlabel('Time (sec)')

%% Aufgabe 3
figure(3)
bode(G_meas,Gvc_mod1);
legend('Measurement','Simulation',location='northwest')

Ks_dB=33.3;
Ks_lin=10^(Ks_dB/20);
f0=7.63;
w0=f0*2*pi;
delataPeak_dB=Ks_dB-21.7;
delataPeak_lin=10^(delataPeak_dB/20);
D_dB=1/2/delataPeak_lin*100;                           % in Prozent

%% Aufgabe 7

% desired closed loop eigenfrequency and damping
w0cl = w0*4;
Dcl = 0.5;

% controller parameters from ideal pd in parallel form
Kp = (w0cl^2/w0^2 - 1) * 1/Ks;
Kd = 2*(Dcl*w0cl - D*w0) * 1/(Ks*w0^2);

% controller parameters from real pd-t1 in time-constant form
Tv = Kd / Kp;
Tf = Tv / 10;

% dc-gain from closed-loop for compensation
Kw = (Kp*Ks)/(1 + Kp*Ks);

% transfer function of pd-t1 controller in time-constant form
Gr = Kp * (Tv*s + 1) / (Tf*s + 1)
