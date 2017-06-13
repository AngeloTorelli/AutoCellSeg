function [ exImage, dishcoord ] = petridishExtractor(varargin)
%PETRIDISHEXTRACTOR Detects and segments the ROI of the inner petridish. 
%   Performs threshold segmentation of the inner petridish of the IMAGE 
%   by using the most occuring value in the histogram of the processed 
%   image. It returns the mask of the petridish EXIMAGE as well as the 
%   center and the radius of the circle DISHCOORD.
%
%   [ EXIMAGE, DISHCOORD ] = PETRIDISHEXTRACTOR(IMAGE)
%   The preprocessing consist of a contrast limited adaptive histogram 
%   equalization using the exponential distribution and a image filling. 
%
%   Example
%   -------
%   Extracting the petridish of a grayscale image:
%   
%       [mask, circle] = petridishExtractor(original);
%       image          = mask.*original;
%       figure, imshow(original), figure, imshow(image,[]);
%
%
%   [ EXIMAGE, DISHCOORD ] = PETRIDISHEXTRACTOR(IMAGE, DISTRIBUTION) 
%   The preprocessing consist of a contrast limited adaptive 
%   histogram equalization using the given distribution and a image
%   filling. The distribution can be:
%       'uniform'     — Flat histogram
%       'rayleigh'    — Bell-shaped histogram
%       'exponential' — Curved histogram
%
%   Example
%   -------
%   Extracting the petridish of a rgb image using rayleigh distribution:
%
%       [mask, circle] = petridishExtractor(original, 'rayleigh');
%       image          = mask.*double(original(:,:,2));
%       figure, imshow(original), figure, imshow(image,[]);
%   
%   
%   
%   
% Open-Source Project Clausel



    %% Check all input arguments
    if nargin == 1 
        parameter.distribution = 'exponential';
        if ~isempty(size(varargin{1},3))
            hsv = rgb2hsv(varargin{1});
            v   = hsv(:,:,3);
        else
            v   = varargin{1};
        end
    elseif nargin == 2
        if ~isempty(varargin{2})
            if strcmp(varargin{2}, 'exponential') == 1
                parameter.distribution = 'exponential';
            elseif strcmp(varargin{2}, 'uniform') == 1
                parameter.distribution = 'uniform';
            elseif strcmp(varargin{2}, 'rayleigh') == 1
                parameter.distribution = 'rayleigh';
            else
                errordlg('Please use exponential, rayleigh or uniform as a distribution.')
            end
        end
    else
        errordlg('Please use only the required input arguments');    
    end

    %% Preprocessing of the image
    A           = adapthisteq(v,'Distribution', parameter.distribution);
    im          = double(mean(A, 3));
    [H, W]      = size(im);
    filled      = imfill(im, 'holes');

    %% Threshold detection using most occuring value in histogram
    [f, i]      = hist(filled(:), 255);
    BW1         = filled <= i(find(f == max(max(f))))+0.01; %#ok<*FNDSB>
    BW2         = filled >= i(find(f == max(max(f))))-0.01;
    BW          = BW1 & BW2;

    %% Extraction of the biggest blob
    infos       = regionprops('table', BW, 'Area', 'Centroid', ...
                              'MajorAxisLength','MinorAxisLength');
    index       = find(infos.Area == max(max(infos.Area)));
    maxax       = infos.MajorAxisLength(index);
    minax       = infos.MinorAxisLength(index);
    ratioArea   = infos.Area(index)/(H*W);
    ratioAxis   = minax/maxax;
    
    if ratioArea > 0.25 && ratioAxis > 0.8
        %% Creation of a circle fitting the inner petridish
        radius      = (maxax + minax)/4;
        x           = infos.Centroid(index,1); 
        y           = infos.Centroid(index,2);
        [x,y]       = meshgrid(-(x-1):(W-x),-(y-1):(H-y));
        exImage     = ((x.^2+y.^2)<=(radius-0)^2);
        dishcoord   = [infos.Centroid(index,:) radius];
    else
        exImage     = true(H, W);
        dishcoord   = [];
    end
end