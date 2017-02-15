%DEPRICATED
function [ feas_imBLOB ] = removebadBLOBS(imblob, bloblims)

if size(imblob,3) < 2
    
    feat   = regionprops(logical(imblob), 'Area', 'Extent', ...
        'SubarrayIdx', 'BoundingBox', 'Centroid', 'PixelIdxList', ...
        'PixelList', 'EquivDiameter', 'Eccentricity');
    
    if mean(bloblims) > 1
        
        for j = 1:length(feat)
            if (feat(j).Area < min(bloblims))
                imblob(feat(j).PixelIdxList)= 0;
            end
        end
        
        feat = regionprops(logical(imblob), 'Area', 'PixelIdxList');
        for j = 1:length(feat)
            if (feat(j).Area > max(bloblims))
                imblob(feat(j).PixelIdxList)= 0;
            end
        end
    else
        
        for j = 1:length(feat)
            if (feat(j).Eccentricity < min(bloblims))
                imblob(feat(j).PixelIdxList)= 0;
            end
        end
        feat = regionprops(logical(imblob),'Eccentricity', 'PixelIdxList');
        
        for j = 1:length(feat)
            if (feat(j).Eccentricity > max(bloblims))
                imblob(feat(j).PixelIdxList)= 0;
            end
        end
    end
    
else
    CC     = bwconncomp(imblob, 26);
    feat   = regionprops(CC, 'Area', 'PixelIdxList');
    
    if mean(bloblims) > 1
        for j = 1:length(feat)
            if (feat(j).Area < min(bloblims))
                imblob(feat(j).PixelIdxList)= 0;
            end
        end
        CC     = bwconncomp(imblob, 26);
        feat   = regionprops(CC, 'Area', 'PixelIdxList');
        for j = 1:length(feat)
            if (feat(j).Area > max(bloblims))
                imblob(feat(j).PixelIdxList)= 0;
            end
        end
    else
        for j = 1:length(feat)
            if (feat(j).Eccentricity < min(bloblims))
                imblob(feat(j).PixelIdxList)= 0;
            end
        end
        feat   = regionprops(CC, 'Eccentricity', 'PixelIdxList');
        for j = 1:length(feat)
            if (feat(j).Eccentricity > max(bloblims))
                imblob(feat(j).PixelIdxList)= 0;
            end
        end    
        
    end
end
    
    
    feas_imBLOB = imblob;