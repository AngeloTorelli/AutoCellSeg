function [ imblob ] = autodilate( image, imblob, se, range, reffeat, par )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if strcmp(se, 'disk') == 1
    Q = zeros(length(range), 1);
    
    for i = 1 : numel(range)
        im   = imdilate(imblob, strel(se, range(i)));
        im   = imfill(im, 'holes');
        im   = imopen(im, strel('disk', 15));
        im   = removebadBLOBS(im, [5000 50000]);
        
        [q, qv, ~] = feateval(image, im, reffeat);
        Q(i)       = q;
        fprintf('Q of SE(%s) with size(%2i) is: %1.3f\n', se, i, q)
        fprintf('y1 = %1.3f, y2 = %1.3f and y4 = %1.3f \n', ...
            qv(:,1),qv(:,2),qv(:,4))
    end
    
    index  = find(Q == max(Q));
    im     = imdilate(imblob, strel(se, range(index(1))));
    im     = imfill(im, 'holes');
    im     = imopen(im, strel('disk', 15));
    imblob = removebadBLOBS(im, [5000 50000]);
    
elseif strcmp(se, 'line') == 1
    Q1 = zeros(length(range), 1);
    Q2 = zeros(length(range), 1);
    Q3 = zeros(length(range), 1);
    
    for i = 1 : numel(range)
        angle = 0;
        im    = imdilate(imblob, strel(se, range(i), angle));
        im    = imfill(im, 'holes');
        im    = imopen(im, strel('disk', 15));
        im    = removebadBLOBS(im, [100000 900000]);
        
        [q, qv, ~] = feateval(image, im, reffeat, par);
        Q1(i)      = q;
        fprintf('Q of SE(%s) with size(%2i) at angle(%2i) is: %1.2f\n', ...
            se, i, angle, q)
        fprintf('y1 = %1.3f, y2 = %1.3f and y4 = %1.3f \n', ...
            qv(:,1), qv(:,2), qv(:,4))
        
        angle = 90;
        im    = imdilate(imblob, strel(se, range(i), angle));
        im    = imfill(im, 'holes');
        im    = imopen(im, strel('disk', 15));
        im    = removebadBLOBS(im, [5000 50000]);
        
        [q, qv, ~] = feateval(image, im, reffeat, par);
        Q2(i)      = q;
        fprintf('Q of SE(%s) with size(%2i) at angle(%2i) is: %1.2f\n', ...
            se, i, angle, q)
        fprintf('y1 = %1.3f, y2 = %1.3f and y4 = %1.3f \n', ...
            qv(:,1), qv(:,2), qv(:,4))
        
        % angle = [0 90];
        im    = imdilate(imblob, strel(se, range(i), 0));
        im    = imfill(im, 'holes');
        im    = imdilate(im, strel(se, range(i), 90));
        im    = imfill(im, 'holes');
        im    = imopen(im, strel('disk', 15));
        im    = removebadBLOBS(im, [5000 50000]);
        
        [q, qv, ~] = feateval(image, im, reffeat, par);
        Q3(i)      = q;
        fprintf('Q of SE(%s) with size(%2i) at angle(%2i) is: %1.2f\n', ...
            se, i, angle, q)
        fprintf('y1 = %1.3f, y2 = %1.3f and y4 = %1.3f \n', ...
            qv(:,1), qv(:,2), qv(:,4))
        
    end
    
    Q     = [Q1 Q2 Q3];
    index = find(Q == max(max(Q)));
    index = index(1);
    newi  = index;
    
    if index > numel(range) && index <= 2*numel(range)
        index = rem(index, length(range));
        angle = 90;
    elseif index > 2*numel(range)
        index = rem(index, 2*length(range));
    else
        angle = 0;
    end
    
    if newi <= 14
        im     = imdilate(imblob, strel(se, range(index), angle));
        im     = imfill(im, 'holes');
        im     = imopen(im, strel('disk', 15));
        imblob = removebadBLOBS(im, [5000 50000]);
    else
        im     = imdilate(imblob, strel(se, range(index), 0));
        im     = imfill(im, 'holes');
        im     = imdilate(im, strel(se, range(index), 90));
        im     = imfill(im, 'holes');
        im     = imopen(im, strel('disk', 15));
        imblob = removebadBLOBS(im, [5000 50000]);
    end
    
end



end
