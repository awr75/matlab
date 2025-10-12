function sdr_am_fm_beispiel(audio)
% Beispiel zur AM- und FM-Modulation mit Verarbeitung im Basisband
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

if nargin == 0
    audio = 1;
end

% Signal lesen
if exist('audioread','file')
    [x,f_a] = audioread('radio.wav');
else
    [x,f_a] = wavread('radio.wav');
end
x = x.';
t = (1 : length(x)) / f_a;

if audio == 1
    print_flush('Originalsignal aus Rundfunksendung ... ');
    audio_ausgabe(x,f_a);
    print_flush('OK\n');
end

% einseitige Bandbreite auf 3.2 kHz begrenzen
% => zweiseitige Bandbreite = 6.4 kHz
h   = lowpass_filter(6400 / f_a);
x_h = filter(h,1,x);

if audio == 1
    print_flush('Bandbegrenztes Sendesignal ... ');
    audio_ausgabe(x_h,f_a);
    print_flush('OK\n');
end

print_flush('Modulation, Addition von Rauschen und Demodulation ... ');

% Traegerfrequenz
f_0 = 10000;

% AM-Modulation
c_am = 2.5;
x_am = (1 + c_am * x_h) .* cos(2 * pi * f_0 * t);

% Spektrogramm und Spektrum des AM-Signals berechnen
[sg_am,f_am,t_am]  = power_spectrum_density(x_am,f_a,1024,4);
sg_am(sg_am < -100) = -100;
s_am = power_spectrum_density(x_am,f_a,1024);

% FM-Modulation
c_fm = 2;
phi  = c_fm * cumsum(x_h);
x_fm = cos(2 * pi * f_0 * t + phi);

% Spektrogramm und Spektrum des FM-Signals berechnen
[sg_fm,f_fm,t_fm] = power_spectrum_density(x_fm,f_a,1024,4);
sg_fm(sg_fm < -100) = -100;
s_fm = power_spectrum_density(x_fm,f_a,1024);

% Rauschen addieren
p_n    = 0.0048;
x_am_n = x_am + sqrt(p_n) * randn(1,length(x_am));
x_fm_n = x_fm + sqrt(p_n) * randn(1,length(x_fm));

% Spektren mit Rauschen berechnen
s_am_n = power_spectrum_density(x_am_n,f_a,1024);
s_fm_n = power_spectrum_density(x_fm_n,f_a,1024);

% Filter fuer die I/Q-Demodulation
h_am = lowpass_filter(8000 / f_a);
h_fm = lowpass_filter(16000 / f_a);

% I/Q-Demodulation = Uebergang ins Basisband
f_off   = 77;
x_mix   = exp( - 2i * pi * (f_0 + f_off) * t );
x_am_bb = filter(h_am,1,x_am_n .* x_mix);
x_fm_bb = filter(h_fm,1,x_fm_n .* x_mix);

% I/Q-Demodulation des AM-Signals ohne Frequenzoffset
x_mix = exp( - 2i * pi * f_0 * t );
x_am_bb_0 = filter(h_am,1,x_am_n .* x_mix);

% Spektren der Basisband-Signale
s_am_bb = power_spectrum_density(x_am_bb,f_a,1024);
s_fm_bb = power_spectrum_density(x_fm_bb,f_a,1024);

% AM-Demodulation
f_g  = 100;
o_g  = 2 * pi * f_g / f_a;
c    = ( 1 - sin(o_g) ) / cos(o_g);
b    = 0.5 * ( 1 + c ) * [ 1 -1 ];
a    = [ 1 -c ];
y_am = filter(b,a,abs(x_am_bb));
y_am = y_am(1000:end);

% FM-Demodulation
dx     = x_fm_bb(2:end) .* conj(x_fm_bb(1:end-1));
omega  = angle(dx);
y_fm_h = filter(h_am,1,omega);
y_fm   = filter(b,a,y_fm_h);
y_fm   = 0.6 * y_fm(1000:end);

print_flush('OK\n');

if audio == 1
    print_flush('Demoduliertes AM-Signal ... ');
    audio_ausgabe(y_am,f_a);
    print_flush('OK\n');
    print_flush('Demoduliertes FM-Signal ... ');
    audio_ausgabe(y_fm,f_a);
    print_flush('OK\n');
end

figure(1);
plot(0.001*f_am,s_am,'b-','Linewidth',1);
hold on;
plot(0.001*f_fm,s_fm,'r-','Linewidth',1);
hold off;
grid on;
axis([0.0005*f_a*[-1 1] -80 0]);
xlabel('f [kHz]');
ylabel('S [dB]');
title('Spektren der Traegersignale');
legend('AM','FM');

figure(2);
imagesc(t_am,0.001*f_am,sg_am.');
set(gca,'YDir','normal');
axis([0 max(t_am) 0.0005*f_a*[-1 1]]);
xlabel('t [s]');
ylabel('f [kHz]');
zlabel('S [dB]');
title('Spektrogramm des AM-Signals');

figure(3);
imagesc(t_fm,0.001*f_fm,sg_fm.');
set(gca,'YDir','normal');
axis([0 max(t_fm) 0.0005*f_a*[-1 1]]);
xlabel('t [s]');
ylabel('f [kHz]');
zlabel('S [dB]');
title('Spektrogramm des FM-Signals');

figure(4);
plot(0.001*f_am,s_am_n,'b-','Linewidth',1);
hold on;
plot(0.001*f_fm,s_fm_n,'r-','Linewidth',1);
hold off;
grid on;
axis([0.0005*f_a*[-1 1] -60 0]);
xlabel('f [kHz]');
ylabel('S [dB]');
title('Spektren der Traegersignale mit Rauschen');
legend('AM','FM');

figure(5);
plot(0.001*f_am,s_am_bb,'b-','Linewidth',1);
hold on;
plot(0.001*f_fm,s_fm_bb,'r-','Linewidth',1);
hold off;
grid on;
axis([0.0005*f_a*[-1 1] -80 0]);
xlabel('f [kHz]');
ylabel('S [dB]');
title('Spektren der Basisbandsignale');
legend('AM','FM');

figure(6);
plot(x_am_bb_0(612000:615000),'b-','Linewidth',1);
grid on;
set(gca,'PlotBoxAspectRatio',[1 1 1]);
axis([-1 1 -1 1]);
xlabel('Re(.)');
ylabel('Im(.)');
title('Ausschnitt aus der Ortskurve des AM-Signals');

figure(7);
plot(x_fm_bb(1000:3000),'r-','Linewidth',1);
grid on;
set(gca,'PlotBoxAspectRatio',[1 1 1]);
axis([-1 1 -1 1]);
xlabel('Re(.)');
ylabel('Im(.)');
title('Ausschnitt aus der Ortskurve des FM-Signals');
