function [ Q ] = qualityBacColSeg( ground_truth, rImages, pars )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Ground truth
gd        = logical(ground_truth);
gd_count  = max(max(bwlabel(gd)));
feat_gd   = regionprops(logical(gd), 'Area', 'PixelIdxList', 'Centroid');
Centroids = zeros(length(feat_gd),2);
for p = 1 : length(feat_gd)
    Centroids(p,1) = feat_gd(p).Centroid(1); 
    Centroids(p,2) = feat_gd(p).Centroid(2);
end

%% Resulting images from different methods

% CellProfiler result
cImage     = imcomplement(rImages(:,:,1));
cImage     = imclearborder(cImage);
cImage       (cImage < 100) = 0;
cImage       (cImage > 100) = 1;
cImage     = bwpropfilt(logical(cImage), 'Area', [100 100000000]);
I          = cImage;

% New method result
nImage     = logical(rImages(:,:,3));
I(:,:,2)   = nImage;

% OpenCFU result
oImage     = rImages(:,:,2);
D          = bwdist(~oImage);
D          = -D;
D(~oImage) = -Inf;
L          = watershed(D);
L          = imclearborder(logical(L));
L          = bwpropfilt(L, 'Area', [400 100000000]);
I(:,:,3)   = L ;

q      = -1*ones(1, size(I,3));
y1_hat = -1*ones(1, size(I,3));
y2_hat = -1*ones(1, size(I,3));

for i = 1 : size(I,3)
    obj_count  = 0;
    im_tmp     = logical(I(:,:,i));
    feat_tmp   = regionprops(im_tmp, 'Area', 'PixelIdxList', 'Centroid');
    for m = 1 : length(feat_tmp)
        tmp_ot = im_tmp(feat_tmp(m).PixelIdxList);
        tmp_gd = gd(feat_tmp(m).PixelIdxList);
        tmp_al = tmp_ot & tmp_gd;
        [k, ~] = dsearchn(Centroids, feat_tmp(i).Centroid);
        
        if length(find(abs(tmp_al))>0) > 0.33 * feat_gd(k).Area
            obj_count = obj_count + 1;
        end
        
    end
    im_dif    = im_tmp - gd;
    cd        = numel(find(im_dif ~= 0));
    q1_hat    = abs(gd_count - obj_count)/gd_count;
    q2_hat    = cd / max(length(find(gd) > 0), ...
                  length(find(im_tmp) > 0));
    y1_hat(i) = evalmf(q1_hat, [0 pars.p1], 'zmf');
    y2_hat(i) = evalmf(q2_hat, [0 pars.p2], 'zmf');
    q(i)      = y1_hat(i) * y2_hat(i) ;
    
end

Q = q;




end

