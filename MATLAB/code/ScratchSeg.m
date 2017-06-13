function [ im_seg, feats ] = ScratchSeg( image, parameters )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

im        = double(mean(image, 3));
io.pixrev = false;
io.switch = 0;

% Input seed from user - selected interactively
[c,r,~]   = impixel(im,[]);
mask      = false(size(im));
for i = 1 : numel(c)
    mask(r(i),c(i)) = true;
end

% Image segmentation
im_nor = im_norm(im, [1 99], 'minmax', io, 0);
im_nor = medfilt2(im_nor, [5 5]);
bw     = edge(imadjust(im_nor), 'canny', 0.1);
bw     = imdilate(bw, ones(5));
bw     = removebadBLOBS(bw,[parameters.minarea .99*size(im,1)*size(im,2)]);
bw     = ~bw;
bw     = imfill(bw, 'holes');
bw     = imopen(bw, strel('disk', 3));
feats  = regionprops(bw, im, 'Area', 'PixelIdxList', 'MeanIntensity');

if numel(r) == 1
    bwt     = bw;
    maxarea = max([feats.Area]);
    bwt     = removebadBLOBS(bwt, [maxarea size(im,1)*size(im,2)]);
    bwn     =  bwt & mask;
    if max(max(bwn)) == 0
        bwt = bw;
        for i = 1 : length(feats)
            imA = bwt(feats(i).PixelIdxList)+mask(feats(i).PixelIdxList);
            if max(imA) < 2
                bwt(feats(i).PixelIdxList) = 0;
            end
        end
        bw = bwt;
    else
        bw = bwt;
    end
else
    for i = 1 : length(feats)
        imA = bw(feats(i).PixelIdxList) + mask(feats(i).PixelIdxList);
        if max(imA) < 2
            bw(feats(i).PixelIdxList) = 0;
        end
    end
end



% Display results
if parameters.vis == 1
    overlay  = imoverlay(im_nor, ...
        imdilate(bwperim(bw),ones(5)), [.9 0 .3]);
    figure;
    imshow(overlay,[])
    title(['Segmented Image : ' parameters.im_name])
end


% Feature calculation
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

feats  = regionprops(bw, im_nor, parameters.feats);

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

im_seg = bw;
end

