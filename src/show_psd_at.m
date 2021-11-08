% Compute power spectrum

% Parameters
timeLimits = seconds([0.0009906258 1.280866]); % seconds
frequencyLimits = [0 4000]; % Hz

%%
% Index into signal time region of interest
data_at_amplitude_ROI = data_at(:,'amplitude');
data_at_amplitude_ROI = data_at_amplitude_ROI(timerange(timeLimits(1),timeLimits(2),'closed'),1);

% Compute spectral estimate
% Run the function call below without output arguments to plot the results
pspectrum(data_at_amplitude_ROI,'FrequencyLimits',frequencyLimits);
