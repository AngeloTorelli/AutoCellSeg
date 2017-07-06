function handles = BacteriaColonySeg(hObject, eventdata, handles)
    
    if handles.maxNum == 1
        set(handles.instructions, 'String', ...
            'Please wait until the algorithm ends.') 
    end
    
    
    guidata(hObject, handles);
    drawnow();       
    
    pars = handles.pars;
    minArea          = handles.minArea;
    maxArea          = handles.maxArea;
    pars.maxcelldiam = handles.maxcelldiam;
    pars.avcellsize  = 1.2*minArea;
    pars.mincellsize = minArea;
    pars.areavec     = [0.5*minArea minArea maxArea 2*maxArea];
    pars.feats       = {'Area', 'MinorAxisLength', ...
                        'MeanIntensity', 'Eccentricity', 'Radius'};
    handles.pars = pars;

    %% Image analysis loop for each image
    if handles.fully
        for i = 1 : length(handles.imgs)
            pars.feats       = {'Area', 'MinorAxisLength', ...
                        'MeanIntensity', 'Eccentricity', 'Radius'};
                    
            handles.pars = pars;
            handles.indexImg = i;
            handles = process(hObject, handles);
        end
    else
        handles = process(hObject, handles);        
    end
    guidata(hObject, handles);
end

function handles = process(hObject, handles)
    pars             = handles.pars;
    im               = handles.imgs{handles.indexImg};
    pars.im_name{handles.indexImg}     = handles.data(handles.indexImg).name;
    inds             = strfind(pars.im_name{handles.indexImg}, ' ');
    t_h              = str2double(pars.im_name{handles.indexImg}(inds-3:inds-1));
    if isnan(t_h)
        t_h = 0;
    end
    pstr             = pwd;
    inds             = strfind(pstr, 'min');
    t_ir             = str2double(pstr(inds-3:inds-1));
    if isnan(t_ir)
        t_ir = 0;
    end
    inds             = handles.inds{handles.indexImg};
    preSelectInfo    = regionprops(handles.BW{handles.indexImg}, 'Area', 'MajorAxisLength', ...
                                       'PixelIdxList', 'Eccentricity');

    
    if ~isempty(inds)
        handles.typestr      = pars.im_name{handles.indexImg}(1:inds(1)-1);
    else
        handles.typestr      = '';
    end
    pars.spmask      = false(size(im,1), size(im,2));
    [handles.BW{handles.indexImg}, ~]  = CellSeg(im, pars);  %%BacteriaColonySeg
    if isfield(handles, 'typestr') == 0
        colour = [.9 .4 .3];
    elseif strcmp(handles.typestr, handles.test) == 1
        colour = [1 0 0];
    elseif strcmp(handles.typestr, handles.control) == 1
        colour = [0 1 0];
    else
        colour = [0 0 1];
    end
    overlay         = imoverlay(handles.imgs{handles.indexImg}, ...
                        imdilate(bwperim(handles.BW{handles.indexImg}), ...
                        ones(3)), colour);
    handles.ov{handles.indexImg}   = overlay;
    % Keeping the originally selected segments
    for newind = 1 : length(preSelectInfo)
        if length(find(handles.BW{handles.indexImg}(preSelectInfo(newind).PixelIdxList)==1)) ...
                < 0.1*length(preSelectInfo(newind).PixelIdxList)
            handles.BW{handles.indexImg}(preSelectInfo(newind).PixelIdxList) = 1;
        end
    end
    if handles.maxNum > 1
        set(handles.instructions, 'String', ...
            ['Please wait while all the pictures are processed (' ...
              num2str(min(100, handles.indexImg/size(handles.imgs, 2)*100)) '%)'])
    end
    seg_count = max(max(bwlabel(handles.BW{handles.indexImg})));
    pars.newfeats     = regionprops(handles.BW{handles.indexImg}, 'Centroid', 'PixelIdxList');
    
        %% Calculate features
    radiusfeatflag = false;
    stdfeatflag    = false;
    medintfeatflag = false;
    
    for k = 1 : length(pars.feats)
        if strcmp(pars.feats(k), 'Radius') == 1
            pars.feats = strrep(pars.feats, ...
                'Radius', 'EquivDiameter');
            radiusfeatflag   = true;
        end
        if strcmp(pars.feats(k), 'StdDeviation') == 1
            pars.feats = strrep(pars.feats, ...
                'StdDeviation', 'PixelValues');
            stdfeatflag   = true;
        end
        if strcmp(pars.feats(k), 'MedianIntensity') == 1
            pars.feats = strrep(pars.feats, ...
                'MedianIntensity', 'PixelValues');
            medintfeatflag   = true;
        end
    end
    
    
    objinfo.pixrev   = false;
    objinfo.switch   = 0;
    if sum(size(handles.norImg{handles.indexImg})) == 0
        handles.norImg{handles.indexImg}= im_norm(double(mean(handles.imgs{handles.indexImg},3)), [1 99], 'minmax', objinfo, 0);
    end;
    
    feats = regionprops(handles.BW{handles.indexImg}, handles.norImg{handles.indexImg}, pars.feats);
    
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
    
    if  sum(sum(handles.BW{handles.indexImg})) > 0
        seg_count = max(max(bwlabel(handles.BW{handles.indexImg})));
    else
        seg_count = 0;
    end
    
    if ~isempty(feats)
        mean_area   = mean([feats.Area]);
        mean_radius = mean([feats.Radius]);
        mean_ecc    = mean([feats.Eccentricity]);
    else
        mean_area   = 0;
        mean_radius = 0;
        mean_ecc    = 0;
    end
    handles.featmat(handles.indexImg, :)   = [seg_count mean_area mean_radius mean_ecc];
    handles.areavec{handles.indexImg}      = [feats.Area];
    
    % Calculate full colony features
    
    if strcmp(handles.typestr, handles.control) == 1
        type        = 1*ones(length(feats),1);
    elseif strcmp(handles.typestr, handles.test) == 1
        type        = 2*ones(length(feats),1);
    else
        type        = 3*ones(length(feats),1);
    end
    
   if numel(inds)>1
       handles.labstr = pars.im_name{handles.indexImg}(inds(1)+1:inds(2)-1);
   else
       handles.labstr = pars.im_name{handles.indexImg};
   end
    if ~isempty(feats)
        fullmattmp = [handles.indexImg*ones(length(feats),1) ...
            (1:length(feats))' [feats.Area]' [feats.MinorAxisLength]' ...
            [feats.Eccentricity]' [feats.MeanIntensity]' ...
            [feats.Radius]' type]; 
    else
        fullmattmp = [];
    end
    
    handles.inds{handles.indexImg} = inds;
    handles.feats{handles.indexImg} = feats;
    handles.fullmat = [handles.fullmat;fullmattmp];        %#ok<AGROW>
    handles.seg_count{handles.indexImg} = seg_count;
    handles.pars = pars;
    guidata(hObject, handles);
    drawnow();
end