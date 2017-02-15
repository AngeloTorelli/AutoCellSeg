function [im_norm, par_vektor_opt] = autonorm_regr(im)
% Autosegmentation of images by tuning parameters
%
% par_permut: Parameter values that have been checked
% par_names: Parameter denotations
% crit_values: Values of the optimization criterion

if nargin < 1, im = imread('A2--W00002--P00001--Z00000--T00000--bf.tif'); end;

% Percentiles to be excluded in quality criterion
perc_thresh = 10;

im = double(im);

[im_norm par_vektor_opt] = normalize_regr(im,1);
crit_min = calc_norm_quality(im_norm, perc_thresh);    

%Output of best segmentation parameters and segmented image
fprintf('Parameters:');
fprintf('\t %1.2f', par_vektor_opt);
% 
% figure; set(gcf,'position', [295 760 945 338]);
% subplot(1,2,1); imagesc(im); title('Original'); colormap gray;
% subplot(1,2,2); imagesc(im_norm);  title([sprintf('Crit.: %1.2f', crit_min) ', Norm. par.:' sprintf('\t %1.2f', par_vektor_opt)]); colormap gray;



