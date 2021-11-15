% Change data format for network training
features_train = cell2mat(features_train);
features_train = reshape(features_train,image_rows,image_cols,1,[]);

features_test = cell2mat(features_test);
features_test = reshape(features_test,image_rows,image_cols,1,[]);

% Represent labels as categorical1
labels_train = categorical(labels_train)';
labels_test = categorical(labels_test)';


classWeights = 1./countcats(labels_train);
classWeights = classWeights'/mean(classWeights);
numClasses = numel(categories(labels_train));

[numHops,numBands,numChannels,numSpec] = size(features_train);
timePoolSize = ceil(numHops/8);

dropoutProb = 0.2;
numF = 12;
layers = [
    imageInputLayer([numHops numBands])

    convolution2dLayer(3,numF,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(3,'Stride',2,'Padding','same')

    convolution2dLayer(3,2*numF,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(3,'Stride',2,'Padding','same')

    convolution2dLayer(3,4*numF,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(3,'Stride',2,'Padding','same')

    convolution2dLayer(3,4*numF,'Padding','same')
    batchNormalizationLayer
    reluLayer
    convolution2dLayer(3,4*numF,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer([timePoolSize,1])

    dropoutLayer(dropoutProb)
    fullyConnectedLayer(numClasses)
    softmaxLayer

    weightedClassificationLayer(classWeights)];


miniBatchSize = 128;
validationFrequency = 5*floor(numel(labels_train)/miniBatchSize);
options = trainingOptions('adam', ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',50, ...
    'MiniBatchSize',miniBatchSize, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'Verbose',false, ...
    'ValidationData',{features_test,labels_test}, ...
    'ValidationFrequency',validationFrequency, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.1, ...
    'LearnRateDropPeriod',20);

net = trainNetwork(features_train,labels_train,layers,options);

save(strcat('.\trained_networks\net_',task_selection,'.mat'),'net')