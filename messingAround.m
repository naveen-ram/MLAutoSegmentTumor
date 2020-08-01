clear all;
load('featuredata.mat');
dims = size(fesdata);

current_data = [fesdata{1,1},fesdata{1,2},fesdata{1,3}]; %for gray
current_class = fesclasses{1,3}; %for gray

trainsize = 8;
testsize = 10 - trainsize;

training_data = current_data(1:trainsize*196608,:);
testing_data = current_data(trainsize*196608+1:end,:); 
training_classes = current_class(1:trainsize*196608,:);
testing_classes = current_class(trainsize*196608+1:end,:); 

models = {@fitcdscr,@fitcecoc,@fitcensemble,@fitcknn,@fitcsvm,@fitctree,@fitcnb};
results = cell(2,length(models));
parfor i=1:length(models)
    t = cputime
    Mdl = models{i}(training_data, training_classes);
    e = cputime-t
    [label,score,cost] = predict(Mdl,testing_data);
    reults{1,i} = Mdl;
    results{2,i} = [label,score,cost];
end


