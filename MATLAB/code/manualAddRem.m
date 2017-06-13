function [ im_seg ] = manualAddRem(im_seg, im, pars)
%MANUALADDREM Allows the user to add new and delete existing bacteria
%   colonies manually.
%   [ IM_SEG ] = MANUALADDREM( IM_SEG, IM_NOR, PARS )
%   Gives the user the opportunity to correct the automated detection
%   manually by adding new or removing existing segments. With the left
%   click the user adds new seed points which are then used to run fast
%   marching and segment. With the right click the nearest center of an
%   existing segment is removed. With the middle click the user ends the
%   manual correction.
%
%   Prerequirements
%   The interaction with an opened figure is required.
%
%   Example
%   -------
%
%       [im_seg, feats]  = CellSeg(im, pars);
%       im               = im_norm(double(mean(im,3)), [1 9], 'minmax', 0);
%       im_seg           = manualAddRem(im_seg, im_nor);
%
% Open-Source Project Clausel

%% Handling dimensions of input image
if pars.chnnlselect == 0
    im = double(rgb2gray(im));
else
    im = double(im(:,:,pars.chnnlselect));
end
oi.pixrev   = false;
oi.switch   = 0;
im_nor      = im_norm(im, [1 99], 'minmax', oi, 0);

%% Extracting the center points of existing mask
ff = regionprops(im_seg, 'Centroid', 'PixelIdxList');

centroids = zeros(length(ff),2);

for j = 1: length(ff)
    centroids(j,1) = ff(j).Centroid(1);
    centroids(j,2) = ff(j).Centroid(2);
end
newcentroids = [];
indices      = [];


%% Adding and deleting centers of bacteria colonies
while 1
    try
        [x,y,button] = ginput(1);
        % Addition of colony centers
        if button == 1
            x               = floor(x);
            y               = floor(y);
            newcentroids    = [newcentroids; [x,y]]; %#ok<*AGROW>
            hold on
            plot(x,y, 'g*')
            hold off
        elseif button == 2
            break;
            % Deletion of colony centers
        elseif button == 3
            x               = floor(x);
            y               = floor(y);
            [k1,d1]         = dsearchn(centroids, [x,y]);
            hold on
            plot(centroids(k1,1),centroids(k1,2), 'r*')
            hold off
            if isempty(newcentroids)
                indices = [indices; k1];
            else
                [k2,d2] = dsearchn(newcentroids, [x,y]);
                if d1 < d2
                    indices = [indices; k1];
                elseif d1 >= d2
                    newcentroids(k2,:) = [];
                end
            end
        end
    catch
        break        
    end
end

%% Deleting existing bacteria colonies
for il = 1:length(indices)
    im_seg(ff(indices(il)).PixelIdxList) = 0;
end
%close(gcf)

%% Adding new segments based on fast marching and seed points using 
%% watershed
if ~isempty(newcentroids)
    ma           = pars.mincellsize;
    IT           = fastMarchingInd(im_nor, newcentroids, ...
                                   pars.maxcelldiam);
    IT           = imopen(IT, strel('disk', 2));
    pars.areavec = [0.5*ma 1*ma 2*ma 5*ma];
    tmp          = false(size(im_seg));
    
    % Add seed points based on graphical input
    for nn = 1 : size(newcentroids,1)
        tmp(newcentroids(nn,2),newcentroids(nn,1)) = 1;
    end
    
    % Dilate the seed point mask
    pars.spmask  = imdilate(logical(tmp), ones(9));
    
    % Do watershed segmentation based on seed points
    IT           = fullimageWS(IT, im_nor, pars);
    
    % Combine the new results with the previously segmented image
    im_seg       = IT | im_seg;
end
