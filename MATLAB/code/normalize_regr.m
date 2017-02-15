function [im_norm par] = normalize_regr(im, regr_opt)
% regr_opt: 1 (quadratic), 2 (cubic)

if nargin < 2, regr_opt = 2; end;

im_model = zeros(size(im));

dim1_values = [1:size(im,1)]'*ones(1,size(im,2));
dim2_values = ones(size(im,1),1) * [1:size(im,2)];

if regr_opt == 1        % quadratic without correlation
    
    fprintf(' z = a0 + a1 x + a2 y + a3 x^2 + a4 y^2\n');
    A = [ones(prod(size(im)),1) dim1_values(:) dim2_values(:) dim1_values(:).^2 dim2_values(:).^2];
    y = im(:);
    par = pinv(A'*A)*A'*y;

elseif regr_opt == 2    % quadratic with correlation
    
    fprintf(' z = a0 + a1 x + a2 y + a3 x^2 + a4 y^2 + a5 xy\n');
    A = [ones(prod(size(im)),1) dim1_values(:) dim2_values(:) dim1_values(:).^2 dim2_values(:).^2 dim1_values(:).*dim2_values(:)];
    y = im(:);
    par = pinv(A'*A)*A'*y;

elseif regr_opt == 3

    fprintf(' z = a0 + a1 x + a2 y + a3 x^2 + a4 y^2 + a5 xy + a6 x^3 + a7 y^3\n');
    A = [ones(prod(size(im)),1) dim1_values(:) dim2_values(:) dim1_values(:).^2 dim2_values(:).^2 dim1_values(:).*dim2_values(:) dim1_values(:).^3 dim2_values(:).^3];
    y = im(:);
    par = pinv(A'*A)*A'*y;

end;


% normalize by found parameters
im_model(:) = A*par;
im_norm = im - im_model;
