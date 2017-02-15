function crit = calc_quality_crit(im, thresh)
% thresh: upper and lower percentile (in percent) to be excluded, 0=maxmin

if nargin < 2, thresh = 10; end;

tmp1 = median(im,1);    % "mean" produces too much influence of the object, not optimal if object becomes too big, but pretty robust
tmp2 = median(im,2);

crit = abs(prctile(tmp1,thresh)-prctile(tmp1,100-thresh))+abs(prctile(tmp2,thresh)-prctile(tmp2,100-thresh));