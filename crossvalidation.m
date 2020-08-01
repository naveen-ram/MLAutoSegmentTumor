clear all
load('modeldatagray3.mat');

t = cputime
Mdl = fitctree(training_data, training_classes,'CrossVal','on');
e = cputime-t
[label,score,cost] = kfoldPredict(Mdl);


load('patient01.mat');
load('patient01tumor_mask.mat');
first = label(1:196608);
ET_inds = find(mask~=0); %”mask” is the original testing patient 3D mask
nonET_inds = find(mask==0);
[~,reordering] = sort([ET_inds; nonET_inds],'ascend');
classes_ordered = first(reordering);
mask_recon = reshape(classes_ordered,size(mask));
figure
vv(mri,mask_recon);
figure
vv(mri,mask);

[X,Y,T,AUC] = perfcurve(testing_classes(1:196608),score(1:196608,2),1);

figure
plot(X,Y)
xlabel('False positive rate') 
ylabel('True positive rate')
title('ROC for Classification by KNN')

cp = classperf(testing_classes(1:196608),label(1:196608));
cp.ErrorRate
cp.Sensitivity
cp.Specificity