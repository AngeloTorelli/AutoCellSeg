function handles = CellSeg(handles)
%CELLSEG Segments the IMAGE in different regions according to the set of
%PARAMETERS.
%   [ IM_SEG, FEATS ] = CELLSEG( IMAGE, PARAMETERS ) 
%   Extracts the inner region of a petridish in case there is one using the
%   petridishExtractor function. Then it performs some preprocessing on the
%   given IMAGE such as gaussian filter and normalizes the IMAGE with
%   im_norm function. Then uses a feedback-based segmentation 
%   (feedbackOtsu function) and runs watershed (fullimageWS function) 
%   on top of the bigger conglomerations to separate them individually. 
%   At the end it removes the illogical segmentations giving the segmented 
%   image back as IM_SEG and calculates all the features and returns them 
%   as FEATS.
%
%   Example
%   -------
%       
%       minArea          = 1000;
%       maxArea          = 3000;
%       pars.wsvector    = 0.01:0.03:0.49;
%       pars.otsuvector  = 0.1: 0.05: 0.97;
%       pars.sImBorder   = 20;
%       pars.avcellsize  = 1.2*minArea;
%       pars.mincellsize = minArea;
%       pars.areavec     = [0.5*minArea minArea maxArea 2*maxArea];
%       pars.avcellecc   = 0.45;
%       [im_seg, feats]  = CellSeg(image, pars);
%
%
% See also petridishExtractor, im_norm, feedbackOtsu, fullimageWS

%% Preporcessing
% Channel selection
if isempty(handles.BW{handles.indexImg})
    empty = true;
else
    empty = false;
    mask = handles.BW{handles.indexImg};
end
% preSelectInfo     = regionprops(handles.BW{handles.indexImg}, ...
%     'Area', 'MajorAxisLength', 'PixelIdxList', 'Eccentricity');
image = handles.imgs{handles.indexImg};
parameters = handles.pars;
if size(image, 3) == 3 && parameters.chnnlselect == 0
    image = double(rgb2gray(image));
else
    if ~isempty(size(image,3)) && size(image, 3) >= parameters.chnnlselect
        image = double(image(:,:,parameters.chnnlselect));
    else
        image = double(image(:,:,1));
    end
end

% Normalization between 0-1
oi.pixrev  = false;
oi.switch  = 0;
im_nor2    = im_norm(image, [1 99], 'minmax', oi, 0);

if mean(mean(im_nor2)) > 0.45
    im     = double(image(:,:,1));
    im     = imcomplement(im);
    im_nor = im_norm(im, [1 99], 'minmax', oi, 0);
    im_nor   (im_nor > 0.8) = 0.8;
else
    im_nor = im_nor2;
end

%% Dish extraction
if parameters.dishextract == true
    [imad, parameters.dc] = petridishExtractor(im_nor);
else
    imad = ones(size(image,1),size(image,2));
end

im_nor = imad.*im_nor;


% Guassian filtering
im_nor1     = imgaussfilt(im_nor,parameters.gausfltsize);
im_nor1      (im_nor1 > 0.8) = 0.8;


if parameters.vis == true
    ov = imoverlay(im_nor1, imdilate(bwperim(imad),ones(3)), [.9 0 .3]);
    figure; imshow(ov,[])
    title(['Segmented Image : ' parameters.im_name])
end

% Background correction
if mean(mean(im_nor2)) > 0.45
    im_nor = imtophat(im_nor1,strel('disk', 90));
else
    im_nor = imtophat(im_nor1,strel('disk', 90));
end

% Histogram equalization
if parameters.adapthist == true
    im_nor = im_norm(adapthisteq(im_nor), [1 99], 'prctile', oi, 0);
else
    im_nor = im_norm(im_nor, [1 99], 'minmax', oi, 0);
end

%% Edge detection

if handles.edge == true
    Ie = edge(im_nor, 'LoG');
    Ie = bwpropfilt(Ie, 'Area', [parameters.areavec(1)*0.5 ...
                                     parameters.areavec(4)*2]);
    Ie = imfill(Ie, 'holes');
    Ie = imdilate(Ie, ones(3));
    Ie = imfill(Ie, 'holes');
    Ie = imopen(Ie, strel('disk', 5));
    Ie = bwpropfilt(Ie, 'Area', [parameters.areavec(1) 100000000]);
else
    Ie = false(size(image));
end

%% Feedback-based segmentation
I  = feedbackOtsu(im_nor, parameters);
I  = I|Ie;

%% Segmentation of big BLOBs
im_seg = fullimageWS(I, im_nor, parameters);

%% Remove illogical BLOBs
im_seg = bwpropfilt(im_seg, 'Eccentricity', [0 0.98]);
im_seg = bwpropfilt(im_seg, 'Area', [parameters.areavec(1) 100000000]);
                                 
if parameters.apriointen
    im_seg = bwpropfilt(im_seg, im_nor, 'MeanIntensity', [handles.Ifeat(1)*0.5 min(handles.Ifeat(2)*1.5, 1)]);
end

if parameters.vis == true
    ov = imoverlay(im_nor, imdilate(bwperim(im_seg),ones(3)), [.9 0 .3]);
    figure; imshow(ov,[])
    title(['Segmented Image : ' parameters.im_name])
end


% % Keeping the originally selected segments
% for newind = 1 : length(preSelectInfo)
%     if length(find(handles.BW{handles.indexImg}(preSelectInfo(newind).PixelIdxList)==1)) ...
%             < 0.1*length(preSelectInfo(newind).PixelIdxList)
%         handles.BW{handles.indexImg}(preSelectInfo(newind).PixelIdxList) = 1;
%     end
% end
if empty
    handles.BW{handles.indexImg} = im_seg;
else
    handles.BW{handles.indexImg} = im_seg | mask;
end

%% Features calculation
radiusfeatflag = false;
stdfeatflag    = false;
medintfeatflag = false;

for k = 1 : length(parameters.feats)
    if strcmp(parameters.feats(k), 'Radius') == 1
        parameters.feats = strrep(parameters.feats, ...
            'Radius', 'EquivDiameter');
        radiusfeatflag   = true;
    end
    if strcmp(parameters.feats(k), 'StdDeviation') == 1
        parameters.feats = strrep(parameters.feats, ...
            'StdDeviation', 'PixelValues');
        stdfeatflag   = true;
    end
    if strcmp(parameters.feats(k), 'MedianIntensity') == 1
        parameters.feats = strrep(parameters.feats, ...
            'MedianIntensity', 'PixelValues');
        medintfeatflag   = true;
    end
end

feats = regionprops(im_seg, im_nor, parameters.feats);

if radiusfeatflag == true
    for j = 1:length(feats)
        feats(j).Radius = feats(j).EquivDiameter/2;
    end
    feats = rmfield(feats, 'EquivDiameter');
end

if stdfeatflag == true
    for j = 1:length(feats)
        feats(j).StdDeviation = std(feats(j).PixelValues);
    end
    
    if isfield(feats, 'PixelValues') && medintfeatflag == false
        feats = rmfield(feats, 'PixelValues');
    end
end

if medintfeatflag == true
    for j = 1:length(feats)
        feats(j).MedianIntensity = median(feats(j).PixelValues);
    end
    
    if isfield(feats, 'PixelValues') && stdfeatflag == false
        feats = rmfield(feats, 'PixelValues');
    end
end

if isfield(feats, 'PixelValues')
    feats = rmfield(feats, 'PixelValues');
end

end


