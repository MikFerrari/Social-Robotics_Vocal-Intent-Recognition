% Feature extraction for both datasets 

[features_kismet, labels_kismet,aFE,image_rows,image_cols] = extract_features(kismet,kismet_fs);
[features_babyYears, labels_babyYears] = extract_features(babyYears,babyYears_fs);

save('.\features\features_kismet.mat','features_kismet','kismet_fs','labels_kismet')
save('.\features\features_babyYears.mat','features_babyYears','babyYears_fs','labels_babyYears')
save('.\features\aFE.mat','aFE')
save('.\features\image_dims.mat','image_rows','image_cols')

% Visualize some spectrograms as an example
figure
t = tiledlayout(2,3);

nexttile
surf(features_train{1,2},'EdgeAlpha',0)
xlabel('Frame Sample')
ylabel('Frequency Band')
zlabel('Power')
title('Approval')

nexttile
surf(features_train{1,3},'EdgeAlpha',0)
xlabel('Frame Sample')
ylabel('Frequency Band')
zlabel('Power')
title('Attention')

nexttile
surf(features_train{1,4},'EdgeAlpha',0)
xlabel('Frame Sample')
ylabel('Frequency Band')
zlabel('Power')
title('Prohibition')

nexttile
surf(features_train{1,2},'EdgeAlpha',0)
xlabel('Frame Sample')
ylabel('Frequency Band')
zlabel('Power')
view(0,90)
title('Approval (2D)')

nexttile
surf(features_train{1,3},'EdgeAlpha',0)
xlabel('Frame Sample')
ylabel('Frequency Band')
zlabel('Power')
view(0,90)
title('Attention (2D)')

nexttile
surf(features_train{1,4},'EdgeAlpha',0)
xlabel('Frame Sample')
ylabel('Frequency Band')
zlabel('Power')
view(0,90)
title('Prohibition (2D)')


function [features,labels,afe,number_rows,number_cols] = extract_features(data,fs)
    frameDuration = 0.025;
    hopDuration = 0.010;
    
    frameSamples = round(frameDuration*fs);
    hopSamples = round(hopDuration*fs);
    overlapSamples = frameSamples - hopSamples;
    
    FFTLength = frameSamples*2;
    numBands = 50;
    
    afe = audioFeatureExtractor( ...
        'SampleRate',fs, ...
        'FFTLength',FFTLength, ...
        'Window',hann(frameSamples,'periodic'), ...
        'OverlapLength',overlapSamples, ...
        'barkSpectrum',true);
    setExtractorParams(afe,'barkSpectrum','NumBands',numBands,'WindowNormalization',false);

    features = {};
    labels = {};

    number_rows = numBands;
    number_cols = 300;

    for i = 1:length(data)
        signal = data(i).Data.amplitude;
        
        feat = extract(afe,signal)';
        feat_resized = imresize(feat,[number_rows number_cols]);

        if ~isempty(feat)
            lab = data(i).Label;
            if strcmp(lab,'pr')
                lab = 'pw';
            end
            labels = [labels lab];
            features = [features feat_resized];
        end
    end

end
