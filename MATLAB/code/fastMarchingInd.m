function mask = fastMarchingInd(image, centers, maxDiam, fft)
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
        endX            = min(startX+d, width);
        endY            = min(startY+d, height);
        crop            = imcrop(image, [startY startX d d]);
        mask2           = false(size(crop));
        mask2(min(r,xi),min(r,yi)) = true;
        grayDiff        = graydiffweight(crop, mask2);
        [mask, ~]       = imsegfmm(grayDiff, mask2, fft);
        mask            = imerode(mask,ones(2));
        clearmask       = imclearborder(mask);
        if sum(sum(clearmask)) == 0 && sum(sum(mask)) > 2 && mask(min(r,xi),min(r,yi)) == 0
            mask        = imcomplement(mask);
            ff          = regionprops(mask, 'Centroid', 'PixelIdxList', 'PixelList');
            centroids = zeros(length(ff),2);
            for j = 1: length(ff)
                centroids(j,1) = ff(j).Centroid(1);
                centroids(j,2) = ff(j).Centroid(2);
            end
            [k2,~] = dsearchn(centroids, [xi,yi]);
            for i = 1:length(ff)
                if k2 == i
                    mask(ff(i).PixelIdxList) = 1;
                else
                    mask(ff(i).PixelIdxList) = 0;
                end
            end
        end      
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