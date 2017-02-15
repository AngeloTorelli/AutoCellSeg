function R = region_grow(I, t)
% function R = region_grow(I, t)
%
% I         Grayscale 2D Image
% t         Threshold for deviation from seed point intensity
% R         Resulting segmentation, a 2D matrix with the same size as I,
%           (-1 = not yet enqueued, 0 = enqueued, 1 = segmented)
%           (0 = background, 1 = segmented)

% convert input image to double

%I = double(I);

% show original image

imshow(I);

% get seed point from mouse click
% hint: use ginput and check its output!

[y1,x1] = ginput;

y1 = uint16(y1);
x1 = uint16(x1);

mask = false(size(I));
mask(x1,y1) = true;

W = graydiffweight(I, mask, 'GrayDifferenceCutoff', 25);

thresh = 0.001;
[BW, D] = imsegfmm(W, mask, thresh);
figure
ov = imoverlay(I, imdilate(bwperim(BW), ones(5)), [0.9 0.7 0.1]);
imshow(ov);
title('Segmented Image')

% store images rows and columns

[height, width] = size(I);

% initialize segmentation image labeling all pixels as not yet enqueued

R = -1 * ones(size(I));

% initialize queue with seed point

Queue(1,:) = [x1 y1];

% label seed point as enqueued in R

% loop for working on the queue
% hint: use isempty

while ~isempty(Queue)


	% pick up and remove first pixel from queue
    
    pixel = Queue(1,:);
	Queue(1,:) = [];
	% check difference to seed point
        
    if (abs(I(x1,y1) - I(pixel(1),pixel(2))) < t)
        R(pixel(1), pixel(2)) = 1;

    % label pixel as segmented in R

        %Label(pixel(1),pixel(2)) = 1;


    % determine neighbors
        neu = [];
        neighbours = get4ngb(height, width, pixel(1), pixel(2));
    % add neighbors to end of queue if not yet enqueued
        for n = 1:size(neighbours)
            if R(neighbours(n,1),neighbours(n,2)) < 0
                neu = [neu;neighbours(n,:)];
                R(neighbours(n,1),neighbours(n,2)) = 0;
            end
        end
        Queue = [Queue; neu];
    end
end
R = uint8(R > 0);
% clean up result image so that we only have background (0) and segmented (1) pixels