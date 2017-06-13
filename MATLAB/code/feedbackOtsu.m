function [ I ] = feedbackOtsu( image, parameters )
%FEEDBACKOTSU Creates a combination of masks generated from a range of
%values found in PARAMETERS.OTSUVECTOR.
%
%   [ I ] = FEEDBACKOTSU(IMAGE, PARAMETERS)
%   Creates a mask I out of the IMAGE by using a series of threshold 
%   values. The values are extracted from PARAMETERS.OTSUVECTOR and each
%   mask is then combined into one.
%
%   Example
%   -------
%   
%       minArea          = 1000;
%       maxArea          = 3000;
%       parameters.vis   = true
%       pars.sImBorder   = 20;
%       pars.wsvector    = 0.01:0.03:0.49;
%       pars.otsuvector  = 0.1: 0.05: 0.97;
%       pars.avcellsize  = 1.2*minArea;
%       pars.areavec     = [0.5*minArea minArea maxArea 2*maxArea];
%       pars.avcellecc   = 0.45;
%       I = feedbackOtsu(image, parameters);
%
%   
% Open-Source Project Clausel

%% Check all input arguments
if isempty(size(image,3))
    image = rgb2gray(image);
end

if isempty(parameters.otsuvector)
    parameters.otsuvector = 0.1: 0.05: 0.97;
end

%% Parameters
I   = false(size(image));
min = parameters.areavec(1);
max = parameters.areavec(4);

%% Combination of masks generated for each otsu value 
for i = 1 : length(parameters.otsuvector)
    bw = im2bw(image, parameters.otsuvector(i)); %#ok<*IM2BW>
    bw = bwpropfilt(bw, 'Area', [min max]);
    bw = imfill(bw, 'holes');
    bw = bwpropfilt(bw, 'Area', [min max]);
    bw = imfill(bw, 'holes');
    
    if parameters.areavec(2) < 200
        bw = imopen(bw, strel('disk', ceil(3/parameters.otsuvector(i))));
    else
        bw = imopen(bw, strel('disk', ceil(7/parameters.otsuvector(i))));
    end
    
    bw = bwpropfilt(bw, 'Eccentricity', [0 0.98]);
    bw = bwpropfilt(bw, 'Area', [min max]);
    I  = I | bw;
end

if parameters.vis == true
    overlay = imoverlay(image, ...
        imdilate(bwperim(I),ones(3)), [.9 0 .3]);
    figure;
    imshow(overlay,[])
    title(['Segmented Image : ' parameters.im_name])
end