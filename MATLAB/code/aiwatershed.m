function [ L ] = aiwatershed( image, blob, parameters )
%AIWATERSHED Subdivides bigger conglomerations into individual segments.
%   [ L ] = AIWATERSHED( IMAGE, BLOB, PARAMETERS )
%   Takes binary image segments of the IMAGE and subdivides the BLOB into
%   smaller blobs according to the criteria found in PARAMETERS. The size
%   of the BLOB is the main criteria for the amount of subdivisions
%   depending on the number of time a average segments fits in. IMAGE is
%   any image which contains any object and BLOB is the binary mask of this
%   object.
%
%   Example
%   -------
%
%
%       minArea          = 1000;
%       maxArea          = 3000;
%       im               = double(imread('coins.jpg'));
%       pars.wsvector    = 0.01:0.03:0.49;
%       pars.otsuvector  = 0.1: 0.05: 0.97;
%       pars.avcellsize  = 1.2*minArea;
%       pars.seedmask    = false(size(im,1), size(im,2))
%       pars.seedmask    = false(size(image));
%       pars.areavec     = [0.5*minArea minArea maxArea 2*maxArea];
%       pars.avcellecc   = 0.45;
%       L                = aiwatershed(image, blob, parameters);
%

imt      = adapthisteq(image);
L        = cell(size(image,1), size(image,2), numel(parameters.wsvector));
y        = -1*ones(length(parameters.wsvector), 1);
blobsize = length(find(blob==0));


%% Selection between Automatic seed detection/External seeds mode
% ex_n is the expected number of segments to be found for each big BLOB
if max(max(bwlabel(parameters.spmask))) == 0
    ex_n = ceil(blobsize/(parameters.avcellsize));
else
    ex_n = max(max(bwlabel(parameters.seedmask)));
end

fblob    = regionprops(blob, 'Eccentricity');
boundary = imdilate(bwperim(blob), ones(5));
imtc     = imcomplement(image);

% Do watershed only if BLOBs are of more elongated shape
if fblob.Eccentricity > parameters.avcellecc*0.75
    if sum(sum(parameters.seedmask)) > 0
        % External seeds mode
        mask_em   = parameters.seedmask;
        imod      = imimposemin(imtc, ~blob | mask_em);
        Lt        = watershed(imod);
        Lt(Lt>0)  = 1;
        L         = imclearborder(Lt);
    else
        % Automatic seed detection
        for i = 1 : length(parameters.wsvector)
            mask_em   = imextendedmax(imt, parameters.wsvector(i));
            mask_em   = imfill(mask_em, 'holes');
            bmask     = boundary & mask_em;
            mask_em   = mask_em - bmask;
            mask_em   = imclearborder(mask_em);
            imod      = imimposemin(imtc, ~blob | mask_em);
            Lt        = watershed(imod);
            Lt(Lt>0)  = 1;
            L{i}      = imclearborder(Lt);
            count     = max(max(bwlabel(L{i})));
            feats     = regionprops(logical(L{i}), 'Area', 'Eccentricity');
            mu        = -1*ones(length(feats),1);
            % Calculate the quality criteria
            for j = 1 : length(feats)
                mu1   = evalmf(feats(j).Area, ...
                    [parameters.areavec(1) parameters.areavec(2) ...
                    parameters.areavec(2)*2 ...
                    max(parameters.areavec(2)*2, ...
                    parameters.areavec(3))], 'trapmf');
                mu2   = evalmf(feats(j).Eccentricity, [0 .1 .5 .85], ...
                    'trapmf');
                mu(j) = mu1*mu2;
            end
            
            mu        = prod(mu);
            mu3       = evalmf(count, [1 ex_n 2*ex_n 3*ex_n-1], 'trapmf');
            y(i)      = (mu*mu3);
        end
        
        % Select the result with maximum quality
        if max(y) > 0
            if ex_n == 1
                ind  = find(y>0);
            else
                ind  = find(y == max(y));
            end
            L        = L{ind(1)};
        else
            % If the automatic loop fails enter a detour one-go
            % segmentation based on supressing outlier pixels on the higher
            % side of the image intensity histogram
            maxthresh = prctile(image(:),95);
            image       (image > maxthresh) = median(image(:));
            image     = imfill(image, 'holes');
            mask_em   = imextendedmax(image, ...
                                      0.25*mean(parameters.wsvector));
            mask_em   = imfill(mask_em, 'holes');
            mask_em   = imopen(mask_em, strel('disk', 5));
            mask_em   = bwpropfilt(mask_em, 'Area', ...
                                   [50 parameters.areavec(4)]);
            bmask     = boundary & mask_em;
            mask_em   = mask_em - bmask;
            mask_em   = imclearborder(mask_em);
            imtc      = imcomplement(image);
            imod      = imimposemin(imtc, ~blob | mask_em);
            Lt        = watershed(imod);
            Lt(Lt>0)  = 1;
            L         = imclearborder(Lt);
            if max(max(bwlabel(L))) < 2
                L     = blob;
            end
        end
    end
    
    % Display the overlaid result
    if parameters.vis == true
        rgb =  label2rgb(L,'jet',[.5 .5 .5]);
        figure;
        imshow (rgb,[])
        title  ('watershed result')
    end
    
else
    L = zeros(size(image));
end

end