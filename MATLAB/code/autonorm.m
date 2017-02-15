function [par_permut, par_names, crit_values, im_norm] = autonorm(im)
% Autosegmentation of images by tuning parameters
%
% par_permut: Parameter values that have been checked
% par_names: Parameter denotations
% crit_values: Values of the optimization criterion

if nargin < 1, im = imread('A2--W00002--P00001--Z00000--T00000--bf.tif'); end;

im = double(im);

% Optimal criterium to be minimized
crit_min = 1e100;
crit_values = [];

% Percentiles to be excluded in quality criterion
perc_thresh = 10;

% set parameters to be optimized in segmentation
par_names = str2mat('center dim1', 'center dim2', 'exp dim1', 'exp dim2', 'slope dim1', 'slope dim2');  %z_new(x,y) = z_alt(x,y) + sd2(x-cd2)^ed2+ sd1(y-cd1)^ed1

par_margins = [ 600 700 50;        % minimum value, maximum value, step, i.e. 1 9 2 = [1 3 5 7 9]
                500 600 50;
                2 2 0.2;
                2 2 0.2;
                0.002 0.02 0.004;             % do not use zero values!!!
                0.002 0.02 0.004
                ];

[im_norm, a] = autonorm_regr(im);      

par_margins = [ -a(2)/(2*a(4)) -a(2)/(2*a(4)) 1;        % minimum value, maximum value, step, i.e. 1 9 2 = [1 3 5 7 9]
                -a(3)/(2*a(5)) -a(3)/(2*a(5)) 1;
                1.99 2.01 0.005;
                1.99 2.01 0.005;
                -a(4) -a(4) a(4)/10;             % do not use zero values!!!
                -a(5) -a(5) a(5)/10
                ];
 
% Generate all combinations of parameters --> to be replaced by nonlinear
% optimization later-on
par_str='';
for i = 1:size(par_margins,1)
    par_str=[par_str sprintf('[%f:%f:%f], ', par_margins(i,1), par_margins(i,3), par_margins(i,2))];
end;
par_str(end)=[];
par_str(end)=[];
eval(sprintf('par_permut = allcomb(%s);', par_str));

% Check all parameter combinations for quality of segmentation
for i = 1: size(par_permut,1)         
    par_vektor = par_permut(i,:);
    
    fprintf('Optimizing step: %i/%i,\t parameters: ', i, size(par_permut,1));
    fprintf('\t %0.2f \t', par_vektor);
    
    % normalize image
    [im_norm] = normalize (im, par_vektor);
    
    % calculate criterion for normalization quality
    [crit] = calc_norm_quality(im_norm, perc_thresh);

    crit_values = [crit_values; crit];
    if (crit < crit_min)
        crit_min = crit;
        par_vektor_opt = par_vektor;
    end;
    
    fprintf(', Quality: %1.2f \n', crit);
end;

%Output of best segmentation parameters and segmented image
fprintf('Best Parameters:');
fprintf('\t %1.2f', par_vektor_opt);
fprintf(',\t Criterion: %1.2f\n', crit_min);
im_norm = normalize (im, par_vektor_opt);

% figure; %set(gcf,'position', [295 760 945 338]);
% subplot(1,2,1); imagesc(im); title('Original'); colormap gray;
% subplot(1,2,2); imagesc(im_norm); title([sprintf('Crit.: %1.2f', crit_min) ', Norm. par.:' sprintf('\t %1.2f', par_vektor_opt)]); colormap gray;

if sum([(par_vektor_opt == par_margins(:,1)') (par_vektor_opt == par_margins(:,2)')])
    fprintf('Border Optimum! There may be better parameter combinations.');
end;


