function print_flush(text)
% print_flush(text)
%
% Unmittelbare Ausgabe von Text auf die Konsole;
% dabei ist im Falle von Octave ein Auffruf von
% fflush erforderlich
%
%   text - auszugebender Text
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

fprintf(1,text);
if exist('OCTAVE_VERSION','builtin')
    fflush(1);
end
