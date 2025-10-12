function audio_ausgabe(x,f_a)
% audio_ausgabe(x,f_a)
%
% Ausgabe eines Audio-Signals
%
%   x   - Signal
%   f_a - Abtastrate des Signals
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

if ~isreal(x)
    x = real(x);
end
if exist('wavplay','file')
    wavplay(x,f_a);
else
    player = audioplayer(x,f_a);
    playblocking(player);
end
pause(1);
