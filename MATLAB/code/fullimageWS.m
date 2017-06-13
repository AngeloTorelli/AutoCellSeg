function [ im_seg ] = fullimageWS(mask, image, parameters)
%FULLIMAGEWS Runs watershed for each individual segment found in the MASK.
%   [ IM_SEG ] = FULLIMAGEWS(MASK, IMAGE, PARAMETERS) Subdivides the
%   picture in the individual segments found in the MASK and runs the
%   watershed algorithm on them. The MASK is a logical image of the actual
%   IMAGE and should contain the segmented region of interest. The
%   watershed algorithm is explained in aiwatershed.
%
%   Example
%   -------
%       
%       pars.sImBorder   = 20;
%       pars.maxcelldiam = max([preSelectInfo.MajorAxisLength]);
%       pars.avcellsize  = 1.2*minArea;
%       pars.areavec     = [0.5*minArea minArea maxArea 2*maxArea];
%       pars.avcellecc   = 0.45;
%       mask   = feedbackOtsu(image, parameters);
%       im_seg = fullimageWS(mask, image, parameters);
%
%
%   See also feedbackOtsu and aiwatershed.

%% Parameters extraction
feats                 = regionprops(mask, image, 'Area',... 
                        'Image', 'PixelIdxList', 'BoundingBox');
% Select the BLOB indices for watershed segmentation
bigBind               = find([feats.Area]>0.7*median([feats.Area]));
b                     = parameters.sImBorder;
ws_tmp                = false(size(image));
im_seg                = logical(mask);
parameters.avcellsize = median([feats.Area]);
norm_info.pixrev      = false;
norm_info.switch      = 0;

%% Watershed on each individual section of the mask
for k = 1 : length(bigBind)
    % Cropping
    r      = round(feats(bigBind(k)).BoundingBox);
    bb     = [r(1)-b r(2)-b r(3)+2*b-1 r(4)+2*b-1];
    im_tmp = imcrop(image, bb);
    im_tmp = im_norm(im_tmp, [1 99], 'minmax', norm_info, 0);
    imb    = false(size(mask));
    imb      (feats(bigBind(k)).PixelIdxList) = 1;
    imb    = imcrop(imb, bb);
    % Seed points mask cropping
    parameters.seedmask = imcrop(parameters.spmask, bb);

    % Watershed segmentation
    L      = aiwatershed(im_tmp, imb, parameters);
    
    if max(max(bwlabel(L))) > 0 && sum(sum(L)) > 0.66 * sum(sum(imb))
        [f1, f2] = find(L>0);
        fr       = f1 + bb(2) - 1;
        fc       = f2 + bb(1) - 1;
        ws_tmp(sub2ind(size(image), fr, fc)) = L(sub2ind(size(L), f1, f2));
        im_seg(feats(bigBind(k)).PixelIdxList) = 0;
    end
    
end

im_seg = imfill(logical(im_seg)|ws_tmp, 'holes');

end