function [data, label, subject, fs] = import_wav_be(fileToRead)
%IMPORTFILE(FILETOREAD)
%  Imports data from the specified file
%  FILETOREAD:  file to read

% Import the file
newData = importdata(fileToRead);
fs = newData.fs;
time = (1/fs * [0:numel(newData.data)-1])';
amplitude = newData.data;

data = table(time, amplitude);
data.Properties.VariableNames = {'time', 'amplitude'};
data.time = seconds(data.time);
data = table2timetable(data);

label = fileToRead(end-8:end-7);
subject = fileToRead(end-12:end-11);
