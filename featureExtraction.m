clear all
cd('C:\Users\Naveen Ram\OneDrive\School\Semester 7\EBME 361\Assignments\EBME361_461_finalhw\EBME361_461_finalhw\mat_files_NEW_skullstripped_downsampled');
files = dir('*.mat');
j = 1;
%1
for i = 1:length(files)
    if( mod(i,2)==1)
        patientmri(j) = load(files(i).name);
    else
        patientmask(j) = load(files(i).name);
        j=j+1;
    end
end
fes = {@grayfilts3, @gradfilts3, @haralick3mex, @gaborfeats3};
fesdata=cell(1,length(fes));
fesclasses = cell(1,length(fes));
for j = 1:length(fes)
    patientdata = [];
    training_classes = [];
    for k = 1:length(patientmask)
        ET_data = [];
        nonET_data=[];
        mri = patientmri(k).mri;
        mask = patientmask(k).mask;
        if(j==3)
            scaled = mri-min(mri(:));
            scaled = scaled./max(scaled(:));
            scaled = scaled.*127;
            features = fes{j}(double(round(scaled)),128,3,1,-1);
        else
            features = fes{j}(mri);
        end
        for l = 1:size(features,4) %for each feature...
            currFeatVol = features(:,:,:,l);%isolate that 3D feature volume...
            ET_data = [ET_data, currFeatVol(mask~=0)];%use logical indexing to isolate the ET pixels...
            nonET_data = [nonET_data, currFeatVol(mask==0)];%use logical indexing to isolate the nonET pixels...
            data = [ET_data;nonET_data];
        end
        ET_classes = ones(size(ET_data,1),1);
        nonET_classes = zeros(size(nonET_data,1),1);
        classes = [ET_classes; nonET_classes];
        training_classes = [training_classes; classes];
        patientdata = [patientdata; data];
    end
    fesdata{1,j} = patientdata;
    fesclasses{1,j} = training_classes;
end

save('featuredata.mat','fesdata','fesclasses');