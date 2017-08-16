function handles = manualAddRem(hGui)
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
handles = guidata(hGui); 
i = handles.indexImg;
im_seg = handles.BW{i}; 
im = handles.imgs{i};
pars = handles.pars;

if size(im, 3) == 3 && pars.chnnlselect == 0
    im = double(rgb2gray(im));
else
    if ~isempty(size(im,3)) & size(im, 3) >= pars.chnnlselect
        im = double(im(:,:,pars.chnnlselect));
    else
        im = double(im(:,:,1));
    end
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
        pause(0.05)        
        handles = guidata(hGui); 
        if isfield(handles, 'closing') == 0 || isfield(handles, 'closing') == 1 && ~handles.closing
            if button == 1 && ~isfield(handles, 'zooming')
                x               = floor(x);
                y               = floor(y);
                if x > 0 && x < size(im,2) && y > 0 && y < size(im,1)
                    newcentroids    = [newcentroids; [x,y]]; %#ok<*AGROW>
                    hold on
                    h(size(newcentroids,1)) = plot(x,y, 'g*');
                    hold off
                end
            elseif button == 2
                break;
                % Deletion of colony centers
            elseif button == 3
                x               = floor(x);
                y               = floor(y);
                if ~isempty(centroids)
                    [k1,d1]     = dsearchn(centroids, [x,y]);
                    if isempty(newcentroids)
                        indices = [indices; k1];
                        hold on
                        plot(centroids(k1,1),centroids(k1,2), 'r*')
                        hold off
                    else
                        [k2,d2] = dsearchn(newcentroids, [x,y]);
                        if d1 < d2
                            indices = [indices; k1];
                            hold on
                            plot(centroids(k1,1),centroids(k1,2), 'r*')
                            hold off
                        elseif d1 >= d2
                            newcentroids(k2,:) = [0, 0];
                            if (ishandle(h(k2))) 
                                delete(h(k2));
                            end;
                        end
                    end
                elseif ~isempty(newcentroids)
                    [k2,d2] = dsearchn(newcentroids, [x,y]);
                    newcentroids(k2,:) = [0, 0];
                    if (ishandle(h(k2))) 
                        delete(h(k2));
                    end;
                end
            end
        else            
            if isfield(handles, 'zooming')
                handles = rmfield(handles, 'zooming');
            end
            break
        end
        if isfield(handles, 'zooming')
            handles = rmfield(handles, 'zooming');
        end
        hObject = handles.output;
        guidata(hObject, handles)
    catch ME
        a = ME;
        break        
    end
end


if isfield(handles, 'closing') == 0 || isfield(handles, 'closing') == 1 && ~handles.closing
    %% Deleting existing bacteria colonies
    for il = 1:length(indices)
        im_seg(ff(indices(il)).PixelIdxList) = 0;
    end

    handles.BW{handles.indexImg} = im_seg;
    %close(gcf)

    %% Adding new segments based on fast marching and seed points using 
    %% watershed
    if ~isempty(newcentroids)
        ma           = pars.mincellsize;
        IT           = fastMarchingInd(im_nor, newcentroids, ...
                                       pars.maxcelldiam, handles.ffthresh);
        IT           = imopen(IT, strel('disk', 2));
        pars.areavec = [0.5*ma 1*ma 2*ma 5*ma];
        tmp          = false(size(im_seg));

        % Add seed points based on graphical input
        for nn = 1 : size(newcentroids,1)
            if newcentroids(nn,2) > 0 && newcentroids(nn,1) > 0
                tmp(newcentroids(nn,2),newcentroids(nn,1)) = 1;
            end
        end

        % Dilate the seed point mask
        pars.spmask = imdilate(logical(tmp), ones(9));

        % Do watershed segmentation based on seed points
        if size(newcentroids, 1) > 1
            IT = fullimageWS(IT, im_nor, pars);
        end

        % Combine the new results with the previously segmented image
        handles.BW{handles.indexImg} = IT | im_seg;
    end
else
    handles = rmfield(handles, 'closing');
end

