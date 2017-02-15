function [Jaccard,Dice,Tanimoto,Accuracy,tpr,tnr,fpr,fnr,tp,tn,fp,fn]=evalSegmentation(segm,gt,roiMask)
% gets label matrix for one tissue in segmented and ground truth 
% and returns the similarity indices
% gt is a tissue in ground truth
% segm is the same tissue in segmented image
% roiMask can be specified to get more relevant results
if nargin<3
    roiMask = ones(size(gt));
end
segm = segm>0;
gt = gt>0;
nPix = sum(roiMask(:));
gt=gt(:);
segm=segm(:);

common=sum(gt & segm); 
union=sum(gt | segm); 
cGT=sum(gt); % the number of voxels in gt
cSegm=sum(segm); % the number of voxels in segm

Jaccard=common/union;

Dice=(2*common)/(cGT+cSegm);

fp=(cSegm-common);
fn=(cGT-common);
tp=common;
tn=nPix-union;

Tanimoto = (tp)/(tp+fp+fn);

Accuracy = (tp+tn)/(tp+fp+fn+tn);

tpr = tp/(tp+fn);
fnr = fn/(tp+fn);
tnr=tn/(fp+tn);
fpr=fp/(fp+tn);
return