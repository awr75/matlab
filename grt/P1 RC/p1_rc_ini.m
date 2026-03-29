clc, clear variables
%% model

% parameters
R = 4.7e3;  % Ohm
C = 470e-9; % F


%% step response comparison

% step response simulation (Simulink)
load step_sim_00.mat % save step_sim_00 out

figure(1)
plot(data_sim.time, data_sim.signals(1).values), grid on, hold on
plot(data_sim.time, data_sim.signals(2).values), hold off
xlabel('Time (sec)')
ylabel('Voltage (V)')
legend('Input', 'Capacitor Simulation', ...
    'Location', 'best')
xlim([0.045 0.07])
