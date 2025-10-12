function [x,f_a,f_tones] = sig_mehrfrequenzsignal
% Erzeugung und Darstellung eines Mehrfrequenzsignals (MFV)
% zur Uebertragung der Rufnummer in einem analogen Telefonsystem
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

% Frequenzen der Toene
f_tones = [ 697 770 852 941 1209 1336 1477 ];

% Frequenzpaare fuer die Ziffern 0...9 in Hertz
f_pairs = [ 941 1336 ; 697 1209 ; 697 1336 ; 697 1477 ; 770 1209 ; ...
            770 1336 ; 770 1477 ; 852 1209 ; 852 1336 ; 852 1477 ];

% Telefonnummer
nummer = [ 0 0 4 9 9 1 3 1 8 5 2 5 1 0 1 ];

% Dauer eines Tons in Sekunden
t_tone = 0.2;

% Dauer einer Pause in Sekunden
t_pause = 0.05;

% Dauer der Rampe beim Ein- und Austasten
t_ramp = 0.01;

% Abtastrate des erzeugten Signals
f_a = 8000;

% Erzeugung des Signals
l_ramp = floor(t_ramp * f_a);
ramp_1 = (1:l_ramp) / l_ramp;
ramp_2 = fliplr(ramp_1);
l_nummer = length(nummer);
t_off = 2 * t_pause;
l_signal = ceil(f_a * (l_nummer * (t_tone + t_pause) + 2 * t_off));
x = zeros(1,l_signal);
t = t_off;
for i=1:l_nummer
    idx = floor(t * f_a);
    for k=1:2
        f_tone   = f_pairs(nummer(i)+1,k);
        t_period = 1 / f_tone;
        periods  = floor(t_tone / t_period);
        tone_len = floor(periods * t_period * f_a);
        x_tone = sin(2 * pi * (0 : tone_len) * f_tone / f_a);
        x_tone(1:l_ramp) = x_tone(1:l_ramp) .* ramp_1;
        x_tone(end-l_ramp+1:end) = x_tone(end-l_ramp+1:end) .* ramp_2;
        x(idx:idx+tone_len) = x(idx:idx+tone_len) + 0.5 * x_tone;
    end
    t = t + t_tone + t_pause;
end

% Zeitachse
t = (0 : l_signal - 1) / f_a;

if nargout == 0
    figure(1);
    plot(t,x,'b-','Linewidth',1.5);
    grid on;
    axis([min(t) max(t) -1.1 1.1]);
    xlabel('t [s]');
    title('Mehrfrequenzsignal (MFV)');
    clear x f_a f_tones;
end
