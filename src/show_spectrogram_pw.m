% Compute spectrogram

% Parameters
timeLimits = seconds([0 2.047875]); % seconds
frequencyLimits = [0 4000]; % Hz
overlapPercent = 50;

%%
% Index into signal time region of interest
data_pw_amplitude_ROI = data_pw(:,'amplitude');
data_pw_amplitude_ROI = data_pw_amplitude_ROI(timerange(timeLimits(1),timeLimits(2),'closed'),1);

% Compute spectral estimate
% Run the function call below without output arguments to plot the results
pspectrum(data_pw_amplitude_ROI, ...
    'spectrogram', ...
    'FrequencyLimits',frequencyLimits, ...
    'OverlapPercent',overlapPercent);
