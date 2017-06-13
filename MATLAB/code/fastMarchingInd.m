function mask = fastMarchingInd(image, centers, maxDiam)
%MANUALADDREM Allows the user to add new and delete existing bacteria 
%   colonies manually.
%   [ IM_SEG ] = MANUALADDREM( IM_SEG, IM_NOR )
%   Gives the user the opportunity to correct the automated detection
%   manually by adding new or removing existing bacteria colonies.
%   With the left click the user adds new seed points which are then used 
%   to run fast marching and segment the bacteria colony. With the right
%   click the nearest center of an existing bacteria colony is removed.
%   With the middle click the user ends the manual correction.
%
%   Prerequirements
%   The interaction with an opened figure is required.
%   
%   Example
%   -------
%   
%       [im_seg, feats]  = CellSeg(im, pars);
%       im_nor           = im_norm(double(mean(im,3)), [1 9], 'minmax', 0);
%       im_seg           = manualAddRem(im_seg, im_nor);
%   
% Open-Source Project Clausel

    maskTot         = false(size(image));
    d               = round(maxDiam+20);
    r               = round(d/2);
    width           = size(image,1);
    height          = size(image,2);

    for m = 1:size(centers,1)
        xi              = centers(m,2);
        yi              = centers(m,1);
        startX          = max(xi-r,1);
        startY          = max(yi-r,1);
        endX            = startX+d;
        endY            = startY+d;
        crop            = imcrop(image, [startY startX d d]);
        mask            = false(size(crop));
        mask(r,r)       = true;
        grayDiff        = graydiffweight(crop, mask);
        [mask, ~]       = imsegfmm(grayDiff, mask, 0.02);
        mask            = imfill(mask,'holes');
        maske           = false(size(maskTot));
        if (endX > width)
            endX        = width;
        elseif (endY > height)
            endY        = height;
        end            
        maske(startX:endX, startY:endY) = mask;
        maskTot         = maskTot | maske;
    end
    
    

    mask = maskTot;

end