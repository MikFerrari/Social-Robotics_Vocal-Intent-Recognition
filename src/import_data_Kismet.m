%% Import Kismet dataset
% The script returns the structure "WAV" with the following 3 fields:
% - Data [Table]
% - Label
% - Subject

% Directory where data are located
data_dir_Kismet = '.\data\Kismet\raw';

% Index .wav files
wav_files = dir([data_dir_Kismet '\*.wav']);
wav_files_path = fullfile({wav_files.folder},{wav_files.name})';

% Process .wav files
wav_data = cell(length(wav_files_path),1);
wav_labels = cell(length(wav_files_path),1);
wav_subjects = cell(length(wav_files_path),1);
for i = 1:length(wav_files_path)
    [wav_data{i}, wav_labels{i}, wav_subjects{i}] = import_wav_k(char(wav_files_path(i)));
end

[~,~,~,kismet_fs] = import_wav_k(char(wav_files_path(1)));

kismet_WAV = struct('Data', wav_data, 'Label', wav_labels, 'Subject', wav_subjects);

clearvars -except kismet_WAV kismet_fs
save('.\imported_data\kismet_WAV.mat')