clc, clear variables, close all;

%% Aufgabe 1
 
load data_00.mat

plot(data.time, data.signals(2).values), grid on

Ks = 5.021
Tp = 0.2765 - 0.15665
d1 = 8.351 - Ks
d2 = Ks - 2.349
theta = log(d1 / d2)
D = theta / (sqrt(pi^2 + theta^2))
wd = (2 * pi) / Tp
w0 = wd / sqrt(1 - D^2)
