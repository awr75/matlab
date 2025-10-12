function [r1,r2] = mexaudioout(func,p1,p2,p3,p4)
% [...] = mexaudioout(func,...)
% 
%   Output audio data via default device
% 
%   1) Initialization: len = mexaudioout('init',sr,bps,buf,tref)
%        sr   = sample rate in samples per second
%        bps  = data blocks per second (1...100)
%        buf  = number of internal buffers (2...100)
%        tref = reference time for TOA calculation
%        len  = length of audio data block
% 
%   2) Output data: mexaudioout('data',data,wait)
%        data = real-valued row vector with audio data
%        wait = wait for empty output buffer, if wait > 0
% 
%   3) Stop: mexaudioout('stop')
%
%------------------------------------------------
% (c) Eberhard Gamm (www.ibega.de),
%     LIKE (www.like.e-technik.uni-erlangen.de),
%     2013
%------------------------------------------------

persistent sys_id;

if isempty(sys_id)
    sys_id = check_system;
end

if nargin == 0
    switch sys_id,
        case 1,
            mexaudioout_matlab_32;
        case 2,
            mexaudioout_matlab_64;
        case 3,
            mexaudioout_octave_32;
        case 4,
            mexaudioout_octave_64;
        case 5,
            mexaudioout_octave_linux;
        otherwise,
            error('Nicht unterstuetzt');
    end
    return;
end

if nargin < 5
    p4 = 0;
end
if nargin < 4
    p3 = 0;
end
if nargin < 3
    p2 = 0;
end
if nargin < 2
    p1 = 0;
end

switch sys_id,
    case 1,
        [r1,r2] = mexaudioout_matlab_32(func,p1,p2,p3,p4);
    case 2,
        [r1,r2] = mexaudioout_matlab_64(func,p1,p2,p3,p4);
    case 3,
        [r1,r2] = mexaudioout_octave_32(func,p1,p2,p3,p4);
    case 4,
        [r1,r2] = mexaudioout_octave_64(func,p1,p2,p3,p4);
    case 5,
        [r1,r2] = mexaudioout_octave_linux(func,p1,p2,p3,p4);
    otherwise,
        error('Nicht unterstuetzt');
end
