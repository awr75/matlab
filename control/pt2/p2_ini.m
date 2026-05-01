clc, clear variables
%% model

% parameters
KS=10
D=0.0385
omega0=47.0611

s=tf('s');
GS=KS*omega0^2 / (s^2 + 2*D*omega0*s + omega0^2)

DCL=1
omega0CL=4*omega0

Kp=(omega0CL^2-omega0^2)/(KS*omega0^2)
Kd=2*(DCL*omega0CL - D*omega0)/(KS*omega0^2)
Tv=Kd/Kp

Tf=Tv/10

GV_GCL_target = omega0CL^2 / ((s^2 + 2*DCL*omega0CL*s + omega0CL^2)*(Tf*s + 1))

GR=Kp*(1 + Tv*s)/(Tf*s + 1)
GV=omega0CL^2/(KS * omega0^2 * (Kp + Kd*s))

GV_GCL = GV*GR*GS/(1+GR*GS)
GV_GCL_simpl = minreal(GV_GCL, 0.001)

AZ1=0.2
omegaZ1=omega0


% Analyze the step response of the system
figure(1);
step(GS, GV_GCL, GV_GCL_target);
title('Step Response of the System');
legend('GS', 'GV_GCL', 'GV_GCL_target')
grid on;

figure(2)
bode(GS, GV_GCL, GV_GCL_target); grid on;
legend('GS', 'GV_GCL', 'GV_GCL_target')


zero(GS)
pole(GS)

figure(3)
pzplot(GS, GV*GR*GS); grid on;
legend('GS', 'GV*GR*GS')
legend('GS', 'GV*GR*GS')

GV*GR*GS