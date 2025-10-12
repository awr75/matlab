function sdr_fm_snr_beispiel
% Beispiel zur SNR-Berechnung bei einem FM-Rundfunksignal
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

close all;

% Signal lesen
if exist('audioread','file')
    [x,f_a] = audioread('radio1.wav');
else
    [x,f_a] = wavread('radio1.wav');
end
x = x.';
t = (1 : length(x)) / f_a;

% einseitige Bandbreite auf 4 kHz begrenzen (zweiseitige Bandbreite = 8 kHz !)
M = f_a / 8000;
h = resampling_filter(M);
x = filter(h,1,x);

% Traegerfrequenz
f_0 = 10000;

% FM-Modulation
c_fm = 2;
phi  = c_fm * cumsum(x);
x_fm = cos(2 * pi * f_0 * t + phi);

% Spektrogramm des FM-Signals berechnen
[sg_fm,f_fm,t_fm] = power_spectrum_density(x_fm,f_a,2048,4);
sg_fm(sg_fm < -80) = -80;

% Rauschen addieren
p_n    = 0.0048;
x_fm_n = x_fm + sqrt(p_n) * randn(1,length(x_fm));

% Spektrogramm mit Rauschen berechnen
sg_fm_n = power_spectrum_density(x_fm_n,f_a,2048,4);

% Spektrum in Sprechpause bei 20 s
idx    = find(t_fm > 20,1,'first');
s_fm_n = sg_fm_n(idx,:);

% Echtzeitanzeige des Spektrums mit Leistungsanzeige:
% Anzeige aufbauen
figure(1);
h_sg = plot(0.001*f_fm,sg_fm_n(1,:),'b-','Linewidth',1);
grid;
axis([-20 20 -70 0]);
xlabel('f [kHz]');
ylabel('S [dB]');
% Signalbereich auf der positiven Frequenzachse: 2 kHz < f < 18 kHz
i_1 = find(f_fm > 2000,1,'first');
i_2 = find(f_fm < 18000,1,'last');
idx = i_1 : i_2;
% relative Rauschbandbreite des Blackman-Fensters
w = blackman_window(2048);
nbw_over_rbw = 2048 * w * w' / (sum(w))^2;
% Signalleistung berechnen
%  - Umrechnung von dB in lineare Leistung
%  - Summation ueber den Signalbereich auf der positiven Frequenzachse
%  - Multiplikation mit 2 zur Beruecksichtigung der negativen Frequenzachse
%    (reeles Signal -> Werte auf der negativen Frequenzachse sind gleich)
%  - Division durch die relative Rauschbandbreite
p_s = 2 * sum( 10.^(sg_fm_n(1,idx)/10) ) / nbw_over_rbw;
h_t = title(sprintf('Spektrum @ t = %4.1f s  =>  P_s = %5.3f',...
                    t_fm(1),p_s));
t = clock;
for i = 2 : size(sg_fm_n,1)
    tw = t_fm(i) - etime(clock,t);
    if tw > 0
        pause(tw);
    end
    p_s = 2 * sum( 10.^(sg_fm_n(i,idx)/10) ) / nbw_over_rbw;
    try
        set(h_sg,'YData',sg_fm_n(i,:));
        set(h_t,'String',sprintf('Spektrum @ t = %4.1f s  =>  P_s = %5.3f',...
                                 t_fm(i),p_s));
        drawnow;
    catch
        break;
    end
end
pause(1);

figure(1);
imagesc(t_fm,0.001*f_fm,sg_fm.');
set(gca,'YDir','normal');
axis([0 max(t_fm) -20 20]);
xlabel('t [s]');
ylabel('f [kHz]');
zlabel('S [dB]');
title('Spektrogramm des FM-Signals ohne Rauschen');

figure(2);
imagesc(t_fm,0.001*f_fm,sg_fm_n.');
set(gca,'YDir','normal');
axis([0 max(t_fm) -20 20]);
xlabel('t [s]');
ylabel('f [kHz]');
zlabel('S [dB]');
title('Spektrogramm des FM-Signals mit Rauschen');

figure(3);
plot(0.001*f_fm,s_fm_n,'b-','Linewidth',1);
grid;
axis([-20 20 -70 0]);
xlabel('f [kHz]');
ylabel('S [dB]');
title('Spektrum in der Sprechpause');
