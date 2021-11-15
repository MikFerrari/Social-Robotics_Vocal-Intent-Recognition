function features_norm = normalize_features(features_to_normalize,features_train)
    
    feat_train = cell2mat(features_train);
    mu = mean(feat_train,2);
    sigma = std(feat_train,[],2);

    features_norm = cellfun(@(x) (x-mu)./sigma, features_to_normalize, 'UniformOutput',false);

end

