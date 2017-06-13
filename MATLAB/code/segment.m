function labels = segment(edge,sz,edgesize)
% function labels = segment(edge,sz,edgesize)
%
% Segment domain of given size into regions enclosed by given edge set
% using bwlabeln (image processing toolbox)
%
% Output: 
%   labels: Segmentation label for every voxel
%
% Input:
%   edge: Edge set as obtained from edgedetect
%   sz: Size of image domain, (3x1)-vector
%   edgesize: Thickness of edge set in voxels 
%            (large values help to close holes in the edge set)

% default parameter: edges with thickness 1
if ~exist('edgesize','var')
    edgesize=1;
end

% create label space
labels=ones(sz);

% return if no edge is given
if isempty(edge.vertices)
    return;
end

% pixels corresponding to edge itself
edgepix=unique(round(edge.vertices),'rows');
thin_e=zeros(sz); thin_e(sub2ind(sz,edgepix(:,2),edgepix(:,1),edgepix(:,3)))=1;

% fatten edge set
fat_e=thin_e;

for i=1:edgesize
    fat_e=grow(fat_e);
end

% set label to 0 on fat edge set
labels(fat_e>0)=0;

% find connected components using bwlabeln (image processing toolbox)
labels=bwlabeln(labels,6); 

end

function x_new = grow(x)
% Function to grow level set of 1 by one pixel (in binary image)

x_new=x; 

for i=-1:1
    for j=-1:1
        for k=-1:1
            x_new = x_new + circshift(x,[i j k]) + circshift(x,[-i -j -k]);
        end
    end
end

end