function sys_id = check_system
% sys_id = check_system
%
% System zur Auswahl der mex-Funktionen pruefen
%
%   sys_id = 1: MATLAB 32 unter Windows
%   sys_id = 2: MATLAB 64 unter Windows
%   sys_id = 3: OCTAVE 32 unter Windows
%   sys_id = 4: OCTAVE 64 unter Windows
%   sys_id = 5: OCTAVE unter Linux
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

persistent p;

if isempty(p)
    if ispc
        % Windows
        if ~exist('OCTAVE_VERSION','builtin')
            % MATLAB
            if strcmp(mexext,'mexw32')
                % 32 bit
                p = 1;
            elseif strcmp(mexext,'mexw64')
                % 64 bit
                p = 2;
            else
                error('Unbekannte Extension fuer MATLAB mex-Funktionen');
            end
        else
            % OCTAVE
            c = computer;
            if strcmp(c(1:4),'i686')
                % 32 bit
                p = 3;
            elseif strcmp(c(1:6),'x86_64')
                % 64 bit
                p = 4;
            else
                error('Unbekannte Variante von OCTAVE');
            end
        end
    elseif isunix
        % Linux
        if ~exist('OCTAVE_VERSION','builtin')
            error('Unter Linux muessen Sie OCTAVE verwenden');
        else
            % OCTAVE unter Linux
            p = 5;
        end
    else
        error('Zur Zeit werden nur Windows und Linux unterstuetzt');
    end
end

sys_id = p;
