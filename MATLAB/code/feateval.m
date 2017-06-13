 function [ quality, qual_vars, im_label ] = ...
    feateval( image, imblob, reffeat, par )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

thresh = 0.1;        % threshold for FMM
bord   = par.border;

% FEATUTRE CALCULATION
feat   = regionprops(logical(imblob), image, 'Area', ...
    'PixelIdxList', 'PixelList', 'Centroid', 'Eccentricity', ...
    'BoundingBox', 'MaxIntensity', 'MinIntensity', 'MeanIntensity', ...
    'PixelValues', 'Perimeter', 'Solidity', 'Extent', 'Image');

Q  = -1*ones(length(feat), 1);
y1 = -1*ones(length(feat), 1);
y2 = -1*ones(length(feat), 1);
y4 = -1*ones(length(feat), 1);
y5 = -1*ones(length(feat), 1);
y6 = -1*ones(length(feat), 1);
y7 = -1*ones(length(feat), 1);

for n = 1 : length(feat)
    peak    = 0;           % segment histogram peak
    stdev   = std(feat(n).PixelValues);
    it      = ExtractObjImage(image, feat(n).PixelList, bord);
    
    if stdev > 0.1
        hh    = im2bw(it, par.sumn*1.8);
        hh    = imfill(hh, 'holes');
        hh    = imopen(hh, strel('disk', 35));
        hh    = removebadBLOBS(hh, [2000 40000]);
        fhh   = regionprops(hh, medfilt1(it, 3), 'PixelValues');
        st    = zeros(length(fhh), 1);
        for ob = 1 : length(fhh)
            st(ob) = std([fhh(ob).PixelValues]);
        end
        stdev = median(st);
    end
    
    % fast marching segmetation
    mask    = false(size(it));
    mask      (max(floor(size(mask,1)/2)-1, 1) : ...
              min(floor(size(mask,1)/2)+1, size(mask,1)), ...
              max(floor(size(mask,2)/2)-1, 1) : ...
              min(floor(size(mask,2)/2)+1, size(mask,2))) = 1;
    W       = graydiffweight(it, mask);
    [BW, ~] = imsegfmm(W, mask, thresh);
    BW      = imopen(imfill(BW, 'holes'), strel('disk', 9));
    
    if sum(sum(BW)) > 0
        featseg = regionprops(BW, 'Eccentricity', 'Area');
        segA    = median([featseg.Area]);
        segE    = median([featseg.Eccentricity]);
    else
        segA    = 0;
        segE    = 1;
    end
    
    it  = ExtractObjImage(image, feat(n).PixelList, 1);
    [line, level] = imhist(it,20);
    minIndices    = imregionalmin(medfilt1(line, 3));
    indices       = minIndices .* line;
    
    if par.vis == 1
        figure
        subplot(1,2,1)
        imshow(it,[])
        impixelinfo
        title(['Segment : ' num2str(n)])
        subplot(1,2,2);
        plot(level, line);
        hold on
        plot(level(indices > 0), indices(indices > 0), 'o')
        title('Intensity histogram')
    end
    
    if numel(find(minIndices==1)) >= 2 && segA > 4500 && segE < 0.75
        indloc   = find(minIndices == 1);
        indloc   = indloc(end-1:end);
        
        if abs(indloc(end)- indloc(end-1)) > 3
            peakvec = imregionalmax(medfilt1(line(indloc(1):indloc(2)),3));
            peakind  = find(peakvec > 0);
            peakindf = indloc(1) + floor(median(peakind));
        else
            peakvec = imregionalmax(medfilt1(line,3));
            peakind  = find(peakvec > 0);
            peakindf = floor(max(peakind(end)));
        end
        
        peak = level(peakindf);
        f7   = peak;
        
        if par.sumn < par.medi + (par.maxi - par.mini)*0.2
            f7 = peak + 3*(par.maxi - par.mini)*0.2;
        end
        
    else
        f7 = peak;
    end
    
    if sum(line(1:5)) > 10000 && stdev > 0.1
        f7 = 0;
    end
    
%     % Check Object Plausibilty
%     it   = ExtractObjImage(image, feat(n).PixelList, bord);
%     pval = checkSegPlaus(it, peak, reffeat);
%     
%     if pval < 0.5
%         f7 = 0;
%     end
    
    y1(n) = evalmf(feat(n).Area, reffeat(1,:), 'trapmf');
    y2(n) = evalmf(feat(n).Eccentricity, reffeat(2,:), 'trapmf');
    y4(n) = evalmf(median(feat(n).PixelValues), reffeat(4,:), 'trapmf');
    y5(n) = evalmf(feat(n).Extent, reffeat(5,:), 'trapmf');
    y6(n) = evalmf(stdev, reffeat(6,1:2), 'zmf');
    y7(n) = evalmf(f7, reffeat(7,:), 'trapmf');
    Q(n)  = y1(n)*y2(n)*y4(n)*y5(n)*y6(n)*y7(n);
end

ind_Q = find(Q > par.crithresh);

if ~isempty(ind_Q)
    if numel(ind_Q) > 1
        ind_Q = ind_Q(1:median(reffeat(3,:)));
    end
    
    y1 = y1(ind_Q);
    y2 = y2(ind_Q);
    y4 = y4(ind_Q);
    y5 = y5(ind_Q);
    y6 = y6(ind_Q);
    y7 = y7(ind_Q);
    
    im_seg1 = double(imblob);
    if length(ind_Q) <= median(reffeat(3,:))
        for kkk = 1 : length(ind_Q)
            indtmp = double(ind_Q(kkk));
            im_seg1(feat(indtmp).PixelIdxList) = 10;
        end
    end
    
    im_seg1    (im_seg1 < 10) = 0;
    im_label  = logical(im_seg1);
    
    if ~isempty(ind_Q)
        count = numel(ind_Q);
    else
        count = 0;
    end
    
    y3        = evalmf(count, reffeat(3,:), 'trapmf');
    quality   = mean(Q(ind_Q))*y3;
    qual_vars = [mean(y1) mean(y2) mean(y3) mean(y4) mean(y5) ...
        mean(y6) mean(y7)];
else
    quality   = -2;
    im_label  = zeros(size(imblob));
    qual_vars = zeros(1, size(reffeat,2));
end

end




