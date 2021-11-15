% Cut initial and final silence + Smooth cut signals (moving average)

%% Parameter definition

time_window = 0.01; % length of the window [s] for which computing the spectral energy
overlap_percent = 0.1;
energy_threshold_kismet = 5e-4;
energy_threshold_babyYears = 5e-5;


%% Preprocessing of both datasets

frpintf("Kismet Dataset")
kismet = voicing_filtering(kismet_WAV,kismet_fs,time_window,overlap_percent,energy_threshold_kismet);
frpintf("BabyYears Dataset")
babyYears = voicing_filtering(babyYears_WAV,babyYears_fs,time_window,overlap_percent,energy_threshold_babyYears);

save('.\preprocessed_data\kismet.mat','kismet','kismet_fs')
save('.\preprocessed_data\babyYears.mat','babyYears','babyYears_fs')

function processed = voicing_filtering(data,fs,time_window,overlap_percent,energy_threshold)
    % Compute window for removal of unvoiced segments
    dt = seconds(time_window);
    overlap = overlap_percent*dt;
    
    % Compute window for filtering (smoothing)
    windowSize = floor(time_window*fs); 
    b = (1/windowSize)*ones(1,windowSize);
    a = 1;

    processed = data;

    i = 1;
    while i <= length(processed)
        % Compute Spectral Density window by window
        time = seconds(0);
        old_time = seconds(0);
        spectral_energy = timetable();
        while time <= processed(i).Data.time(end)
            time = time + dt - overlap;
            fft_signal = fft(processed(i).Data.amplitude(old_time:time));
            en = sum(abs(fft_signal).^2)/numel(fft_signal);
            T = timetable(old_time,en);
            spectral_energy = [spectral_energy; T];
            old_time = time;
        end
        spectral_energy.Properties.VariableNames = {'spectral_energy'};
        spectral_energy.Properties.DimensionNames(1) = {'time'};
     
        spectral_energy = retime(spectral_energy,processed(i).Data.time,'linear');
    
        processed(i).Spectral_energy = spectral_energy;
    
        % Cutting and smoothing of the signal
        try
            voiced_idx = (spectral_energy.spectral_energy >= energy_threshold);
            voiced_idx = find(voiced_idx);
            first_idx = voiced_idx(1);
            last_idx = voiced_idx(end);
            processed(i).Data_voiced = processed(i).Data(first_idx:last_idx,:);
            processed(i).Data_voiced.Properties.VariableNames = {'amplitude'};
    
            y = filter(b,a,processed(i).Data_voiced.amplitude);
            processed(i).Data_voiced_filt = timetable(processed(i).Data_voiced.time,y);
            processed(i).Data_voiced_filt.Properties.DimensionNames(1) = {'time'};
            processed(i).Data_voiced_filt.Properties.VariableNames = {'amplitude'};
            i = i+1;
    
        catch
            fprintf(strcat("Removed sample #", string(i),"\n"))
            processed(i) = [];
        end
            
    end

end
