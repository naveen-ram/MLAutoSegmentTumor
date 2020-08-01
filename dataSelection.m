clear all;
load('featuredata.mat');
dims = size(fesdata);

current_data = fesdata{1,1}; %for gray
current_class = fesclasses{1,1}; %for gray

trainsize = 9;
testsize = 10 - trainsize;

training_data = current_data(1:trainsize*196608,:);
testing_data = current_data(trainsize*196608+1:end,:); 
training_classes = current_class(1:trainsize*196608,:);
testing_classes = current_class(trainsize*196608+1:end,:); 

save('modeldatagray3.mat','training_data','testing_data','training_classes','testing_classes')