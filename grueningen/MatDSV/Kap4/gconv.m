function [y,M] = gconv(x,h,o,p)
% Graphical step-by-step convolution of two discrete signals.
%
% CALL
%   [y,F] = gconv(x,h,[3 -2],p);
%   [y,F] = gconv(x,,h,[],p);
%   [y,F] = gconv(x,h);
%
% INPUT 
%   x: input vector.
%   h: input vector.
%   o: [xo, ho]; the index of first sample of x and h respectively. Default
%      is o = [0 0].   
%   p: pause between each step. Default is that the user must strike a key 
%      to continue.
%
% OUTPUT
%   y: the result of the convolution operation.
%   F: captured frames for playback.
%
% See at the end of the m file for "Instructions for instructors".
%
% C. Saragiotis, Apr. 2010, angepasst durch DvG, Nov. 2010 


%% Initialization 
if nargin < 4, p = []; end
if nargin < 3 || isempty(o), o = [0 0]; end

red   = [.8  0  0];    
green = [0  .8 .2];
blue  = [0   0 .8];
grey  = [.5 .5 .5];

figure;
pos = get(gcf,'Position');
pos(4) = round(1.5*pos(4));
%set(gcf,'Position',pos)
set(gcf,'Units','normal','Position',[0.4 0.1 0.5 0.5])

if ~isvector(x) || ~isvector(h)
    error('%s: x and h must be vectors',upper(mfilename)); 
else
    x = x(:);
    h = h(:);
end
    
n = length(x);
m = length(h);

xo = o(1); ho = o(2);

ix = xo + (0:n-1);
ih = ho + (0:m-1);

H = [h; zeros(n,1)];
X = [x; zeros(m,1)];
[Xlim,Ylim] = Conv(x,ix,h,ih);  % make the convolution first to decide the axes limits

nm = n+m-1;
iy = (ix(1)+ih(1))+ (0:nm-1);

y = zeros(nm,1);    

%% show x, h
subplot(311)
    line([0 0],Ylim,'Color',grey), hold on
    line(Xlim,[0 0],'Color',grey);
    h1 = mystem(ix,x,'Color',blue);
    xlim(Xlim); ylim(Ylim);
    xlabel('n')
    tx1 = lgdtext('x[n]');
subplot(312)
    line([0 0],Ylim,'Color',grey), hold on
    mystem(ih,h,'Color',red);
    xlim(Xlim); ylim(Ylim); 
    xlabel('n')
    tx2 = lgdtext('h[n]');
subplot(313)
    line([0 0],Ylim,'Color',grey); hold on
    line(Xlim,[0 0],'Color',grey);
    xlim(Xlim); ylim(Ylim);
M(1) = getframe;
M(Xlim(2)+n+2) = M(1); % preallocation of space
Pause(p)
disp(' '); disp('Weiter mit ENTER'); disp(' ')

%% show x(-k)
subplot(312)
    xlabel('i')
    lgdtext('h[i]',tx2);

subplot(313)
    x = flipud(x);
    X = flipud(X);
    hxk1 = mystem(-xo+(-(n-1):0),x,'Color',blue); 
    hxk2 = mystem(-xo+(-(n-1):0),x,'Color',blue); 
    xlabel('i')
    tx3 = lgdtext('x[-i]');

M(2) = getframe;
Pause(p);   

%% move x(-k) to the appropriate starting position, if necessary
subplot(313)
if -xo<ho-1
    for i = -xo+1:ho-1
        set(hxk1,'Color',.7*[1 1 1],'Linestyle','-.')
        set(hxk2,'Visible','off');
        hxk2 = mystem(i+(-(n-1):0),x,'Color',blue); 
        lgdtext(sprintf('x[%d-i]',i+xo),tx3);
        pause(.05)
    end
elseif -xo>ho-1
    for i = -xo-1:-1:ho-1
        set(hxk1,'Color',.7*[1 1 1],'Linestyle','-.')
        set(hxk2,'Visible','off');
        hxk2 = mystem(i+(-(n-1):0),x,'Color',blue); 
        lgdtext(sprintf('x[%d-i]',i+xo),tx3);
        pause(.05)
    end
else
    i = ho-1;
    set(hxk1,'Color',.7*[1 1 1],'Linestyle','-.')

end
M(3) = getframe;
Pause(p);

    
%% replace x(n) with y(n)
subplot(311)
    set(h1,'Visible','off')
    hy1 = mystem(iy,y,'MarkerSize',4,'Color',green);
    xlabel('n')
    lgdtext('y[n]',tx1);
%     tl1 = legend('$y(n)$',txtalgn); set(tl2,'Interpreter','latex')
M(4) = getframe;
Pause(p)

%% Convolution
k = 0;
for kk = xo+ho-1 + (0:Xlim(2)-(ho-n))
    k = k+1;
    if k <= nm, y(k) = sum((H(1:k).*X((end-k+1):end))); end
    subplot(313)
        set(hxk2,'Visible','off');
        hxk2 = mystem(k+ho-1+(-(n-1):0),x,'Color',blue); 
        ns = sprintf('x[%d-i]',i+xo+k);
        if i+xo+k == 0, ns = 'x[-i]'; end
        lgdtext(ns,tx3);
    subplot(311); 
        set(hy1,'Visible','off')
        hy1 = mystem(iy,y,'Color',green); 
    if k <=nm+1, 
        Pause(p);
    else
        pause(.05)
    end

%     subplot(211); hold off; mystem(xa,a); hold on;mystem(xb,b,'Color',red);
%     xlim([-length(b) mlen]);
    M(k+4) = getframe;
end


%% #### Nested functions ####
%% lgdtext
function h = lgdtext(str,h)
    
a = 0.05;
tx = a*Xlim(1)+(1-a)*Xlim(2);
ty = a*Ylim(1)+(1-a)*Ylim(2);     

if nargin==1
%     h = text(txtx,txty,str,'VerticalAlignment','top','HorizontalAlignment','right'); % 'Interpreter','latex'
    h = text(tx,ty,str);
    set(h,'VerticalAlignment','top','HorizontalAlignment','right'); % 'Interpreter','latex'
else
    set(h,'String',str);     % 'Interpreter','latex'
end
        
end



end


%% #### Local functions ####
%% Pause
function Pause(p)
    if isempty(p)
        eval('pause');
    else
        eval(sprintf('pause(%g)',p));
    end

end

%% Conv
function [Xlim,Ylim] = Conv(x,ix,h,ih)
    n = length(x);
    m = length(h);
    H = [h; zeros(n-1,1)];
    X = flipud([x; zeros(m-1,1)]);

    xh(n+m-1) = 0;
    for k = 1:n+m-1
        xh(k) = H(1:k).'*X(end-k+1:end);
    end 

    xh = [xh(:); x(:); h(:)];
    Xlim = [min([-ix(end),ix(1),ih(1)-n,ix(1)+ih(1)])-2,  max([ix(end)+ih(end),ix(end),ih(end),-ix(1)])+2];
    Ylim = [min(-2,1.5*min(xh)), min(1.5*max(xh),max(xh)+1)];

end

%% mystem
function h = mystem(varargin)
    m = 4;
    h = stem(varargin{:});
    set(h,'MarkerSize',m, 'MarkerFaceColor',get(h,'Color'));
    
    
end



%% Instructions for instructors
% This file shows graphically the steps of the convolution of two discrete
% signals. The display is optimizes for short signals, (i.e. a few
% samples). An example of usage would be 
%   x = [3 4 -1 2]; 
%   h = 1:7;
%   gconv(x,h,[7 -2]);
% where 7 is the index of the first sample of x and -2 is the index of the
% first sample of h.
%
% The convolution is calculated twice. The first time to set the axes
% limits correctly and the second time to show the graphic. The function
% conv of the Signal Processing Toolbox is NOT required.
%
% DESCRIPTION OF SCREENS
% 1st screen: the two signals x[n] and h[n].
% 2nd screen (3rd subplot): x is reversed in time. Notice also that the
%                           xlabel of h has now changed from n to i.
% 3rd screen (3rd subplot): x is shifted appropriately i.e. in such a way
%                           that with the next shift x and h will have
%                           their first common sample. Notice that in the
%                           x[n-i] string n changes accordingly. A faded
%                           version of x[-i] remains (in order to count the
%                           n, if necessary)
% 4th screen (1st subplot): x[n] is not needed now, so y[n] will be plot in
%                           the 1st subplot. Its first value is all 0s.
% 5th - Nth screen: x[n-i] is shifted by 1 sample with every key strike and
%                   the corresponding value of y appears on the 1st
%                   subplot. The n in the x[n-i] string changes accordingly
%                   in every step. 
% (N+1)-th screen: Once there are no common non-zero values between h[i]
% and x[n-i] with the next stroke x[n-i] will leave the screen.