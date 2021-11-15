function [features_train,labels_train,features_test,labels_test] = random_extraction(features,labels,training_percentage)
    
    idx = randperm(length(features));
    idx_train = idx(1:floor(training_percentage*length(idx)));
    idx_test = idx(floor(training_percentage*length(idx))+1:end);
    
    features_train = features(idx_train);
    labels_train = labels(idx_train);
    
    features_test = features(idx_test);
    labels_test = labels(idx_test);

end