%% Import BabyYears dataset
% The script returns the structure "WAV" with the following 3 fields:
% - Data [Table]
% - Label
% - Subject

% Directory where data are located
data_dir_BabyEars = '.\data\BabyEars\raw';

% Index .wav files
wav_files = dir([data_dir_BabyEars '\*.wav']);
wav_files_path = fullfile({wav_files.folder},{wav_files.name})';

% Process .wav files
wav_data = cell(length(wav_files_path),1);
wav_labels = cell(length(wav_files_path),1);
wav_subjects = cell(length(wav_files_path),1);
for i = 1:length(wav_files_path)
    [wav_data{i}, wav_labels{i}, wav_subjects{i}] = import_wav_be(char(wav_files_path(i)));
end

[~,~,~,babyYears_fs] = import_wav_be(char(wav_files_path(1)));

babyYears_WAV = struct('Data', wav_data, 'Label', wav_labels, 'Subject', wav_subjects);

clearvars -except babyYears_WAV babyYears_fs
save('.\imported_data\babyYears_WAV.mat')