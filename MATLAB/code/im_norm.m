function [ I_norm ] = im_norm( im, prc_vec, type, objinfo, vis )
%IM_NORM 
%   [ I_NORM ] = IM_NORM( IM, PRC_VEC, TYPE, OBJINFO, VIS )
if nargin<4
    objinfo.switch = 1;
    objinfo.perc   = 10;
    vis            = false;
end
im     = double(im);
I_low  = prc_vec(1);
I_high = prc_vec(2);
pixrev = objinfo.pixrev;

if isempty(pixrev)
    %background check
    if median(median(im))< max(max(im))
        npix_white = numel(find(im >= median(median(im))));
        npix_black = numel(find(im < median(median(im))));
    else
        npix_white = numel(find(im >= mean(mean(im))));
        npix_black = numel(find(im < mean(mean(im))));
    end
    if  (npix_white>npix_black) && ~isempty(npix_white) ...
            && ~isempty(npix_black)
        pixrev = true;
    end
else
    pixrev = objinfo.pixrev;
end

if isempty(size(im,3))
    
    if (strcmp(type, 'musig') == 1)
        % parameter to describe cell density in an image
        if objinfo.switch == 1
            maxprctcells = objinfo.perc;
        else
            maxprctcells = 40; %#ok<*NASGU>
        end
        
        % Apply normalization based on parameters of normal distribution
        maxprctcells      = objinfo.perc;
        minthresh         = prctile(im(:),maxprctcells);
        maxthresh         = prctile(im(:),100 - maxprctcells);
        ind               = find((im(:) > minthresh)&(im(:) < maxthresh));
        mu                = mean(im(ind));
        s                 = std(im(ind));
        im(im < mu + 2*s) = mu+2*s;
        I_norm            = im;
        
        % string for display
        string = ['Normalized input image using : ' num2str(type) ...
            ' using mean and standard deviation'];
          
    elseif (strcmp(type, 'musig+prctile') == 1)
        % Apply percentile normalization after applying normalization based
        % on parameters of normal distribution
        maxprctcells        = objinfo.perc;
        minthresh           = prctile(im(:),maxprctcells);
        maxthresh           = prctile(im(:), 100 - maxprctcells);
        ind                 = find((im(:) > minthresh) &  ...
                                   (im(:) < maxthresh));
        mu                  = mean(im(ind));
        s                   = std(im(ind));
        im (im < mu + 2*s)  = mu+2*s;
        im_vec              = double(im(:));
        maxthresh           = prctile(im_vec,I_high);
        minthresh           = prctile(im_vec,I_low);
        im (im > maxthresh) = maxthresh;
        im (im < minthresh) = minthresh;
        
        if pixrev == true
            im     = imcomplement(im);
            I_norm = im2double(im);
        else
            I_norm = (im - min(min(im)))/abs(max(max(im)) - min(min(im)));
        end
        
        % string for display
        string = ['Normalized input image using : ' num2str(type) ...
            ' with ' num2str(prc_vec)];
        
    elseif (strcmp(type,'prctile') == 1)
        % Apply percentile normalization
        im_vec              = double(im(:));
        maxthresh           = prctile(im_vec,I_high);
        minthresh           = prctile(im_vec,I_low);
        im(im > maxthresh)  = maxthresh;
        im(im < minthresh)  = minthresh;
        % followed by min-max
        if pixrev == true
            im     = imcomplement(im);
            I_norm = im2double(im);
        else
            I_norm = (im - min(min(im)))/abs(max(max(im)) - min(min(im)));
        end
        
        % string for display
        string = ['Normalized input image using : ' num2str(type) ...
            ' with ' num2str(prc_vec)];
        
    elseif (strcmp(type,'minmax') == 1)
        % Apply min-max normalization
        if pixrev == true
            im     = imcomplement(im);
            I_norm = im2double(im);
            I_norm = (im - min(min(im)))/abs(max(max(im)) - min(min(im)));
        else
            I_norm = (im - min(min(im)))/abs(max(max(im)) - min(min(im)));
        end
        
        % string for display
        string = ['Normalized input image using : ' num2str(type) ...
            ' with ' num2str(prc_vec)];
    else
        error('ErrorTests:convertTest', ...
'The first input argument be either: "prctile", "minmax", "musig+prctile" or "musig" ')
    end
    
    if (vis == true)
        figure
        imshow(I_norm,[])
        title(string)
        impixelinfo
        figure
        hist(im2double(I_norm(:)),100)
        title('Histogram of normalized image')
    end
    
else
    if (strcmp(type, 'musig') == 1)
        
        % parameter to describe cell density in an image
        if objinfo.switch == 1
            maxprctcells = objinfo.perc;
        else
            maxprctcells = 40; %#ok<*NASGU>
        end
        
        % Apply normalization based on parameters of normal distribution
        maxprctcells      = objinfo.perc;
        minthresh         = prctile(im(:),maxprctcells);
        maxthresh         = prctile(im(:),100 - maxprctcells);
        ind               = find((im(:) > minthresh)&(im(:) < maxthresh));
        mu                = mean(im(ind));
        s                 = std(im(ind));
        im(im < mu + 2*s) = mu+2*s;
        I_norm            = im;
        
        % string for display
        string = ['Normalized input image using : ' num2str(type) ...
            ' using mean and standard deviation'];
        
        
    elseif (strcmp(type, 'musig+prctile') == 1)
        % Apply percentile normalization after applying normalization based
        % on parameters of normal distribution
        maxprctcells        = objinfo.perc;
        minthresh           = prctile(im(:),maxprctcells);
        maxthresh           = prctile(im(:), 100 - maxprctcells);
        ind                 = find((im(:)> minthresh)&(im(:) < maxthresh));
        mu                  = mean(im(ind));
        s                   = std(im(ind));
        im (im < mu + 2*s)  = mu+2*s;
        im_vec              = double(im(:));
        maxthresh           = prctile(im_vec,I_high);
        minthresh           = prctile(im_vec,I_low);
        im (im > maxthresh) = maxthresh;
        im (im < minthresh) = minthresh;
        
        if pixrev == true
            im     = imcomplement(im);
            I_norm = im2double(im);
        else
            I_norm = (im - min(min(im)))/abs(max(max(im)) - min(min(im)));
        end
        
        % string for display
        string = ['Normalized input image using : ' num2str(type) ...
            ' with ' num2str(prc_vec)];
        
    elseif (strcmp(type,'prctile') == 1)
        % Apply percentile normalization
        im_vec              = double(im(:));
        maxthresh           = prctile(im_vec,I_high);
        minthresh           = prctile(im_vec,I_low);
        im(im > maxthresh)  = maxthresh;
        im(im < minthresh)  = minthresh;
        % followed by min-max
        if pixrev == true
            im     = imcomplement(im);
            I_norm = im2double(im);
        else
            I_norm = (im - min(im(:))) / abs(max(im(:)) - min(im(:)));
        end
        
        % string for display
        string = ['Normalized input image using : ' num2str(type) ...
            ' with ' num2str(prc_vec)];
        
    elseif (strcmp(type,'minmax') == 1)
        % Apply min-max normalization
        if pixrev == true
            im     = imcomplement(im);
            I_norm = im2double(im);
            I_norm = (im - min(im(:)))/abs(max(im(:)) - min(im(:)));
        else
            I_norm = (im - min(im(:)))/abs(max(im(:)) - min(im(:)));
        end
        
        % string for display
        string = ['Normalized input image using : ' num2str(type) ...
            ' with ' num2str(prc_vec)];
    else
        error('ErrorTests:convertTest', ...
 'The first input argument be either: "prctile", "minmax", "musig+prctile" or "musig" ')
    end
    
end

