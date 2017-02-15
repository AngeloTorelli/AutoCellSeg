%DEPRICATED
function [ ObjImage, newPixInd ] = ...
    ExtractObjImage( bigImage, PixelList, border )
%EXTRACTOBJIMAGE Extracts a section with an extra BORDER of the BIGIMAGE.
%   [ OBJIMAGE, NEWPIXIND ] = EXTRACTOBJIMAGE(BIGIMAGE, PIXELLIST, BORDER)
%   creates a box by adding a BORDER on the bounding box of the PIXELLIST
%   and extracts it from the BIGIMAGE.

%   Example
%   -------
%   feats   = regionprops(mask, 'PixelIdxList');
%   extract = ExtractObjImage(image, feats.PixelList, 10);
%   figure, imshow(extract), figure, imshow(image,[]);
%
%   
% Open-Source Project Clausel

rc        = PixelList;
r1        = max(floor(min(rc(:, 2))) - border, 1);
r2        = min(floor(max(rc(:, 2))) + border, size(bigImage, 1));
c1        = max(floor(min(rc(:, 1))) - border, 1);
c2        = min(floor(max(rc(:, 1))) + border, size(bigImage, 2));

if size(PixelList, 2) < 3
    ObjImage  = bigImage(r1 : r2, c1 : c2);
    newPixInd = [r1 r2; c1 c2];
else
    s1        = max(floor(min(rc(:, 3))) - border, 1);
    s2        = min(floor(max(rc(:, 3))) + border, size(bigImage, 3));
    ObjImage  = bigImage(r1 : r2, c1 : c2, s1 : s2);
    newPixInd = [r1 r2; c1 c2; s1 s2];
end

