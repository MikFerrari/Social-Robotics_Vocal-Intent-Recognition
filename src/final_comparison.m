mat_files = dir('.\evaluation_metrics\*.mat');
for i = 1:length(mat_files)
     assignin('base',mat_files(i).name(1:end-4),load(mat_files(i).name));
end

mean_accuracies = [accuracy_Kismet_vs_Kismet.mean_accuracy;
                   accuracy_Baby_vs_Baby.mean_accuracy;
                   accuracy_Kismet_vs_Baby.mean_accuracy;
                   accuracy_Baby_vs_Kismet.mean_accuracy;
                   accuracy_Kismet_Baby_vs_Kismet.mean_accuracy;
                   accuracy_Baby_Kismet_vs_Baby.mean_accuracy];

lowerCI = [lowerCI_Kismet_vs_Kismet.lower;
           lowerCI_Baby_vs_Baby.lower;
           lowerCI_Kismet_vs_Baby.lower;
           lowerCI_Baby_vs_Kismet.lower;
           lowerCI_Kismet_Baby_vs_Kismet.lower;
           lowerCI_Baby_Kismet_vs_Baby.lower];

upperCI = [upperCI_Kismet_vs_Kismet.upper;
           upperCI_Baby_vs_Baby.upper;
           upperCI_Kismet_vs_Baby.upper;
           upperCI_Baby_vs_Kismet.upper;
           upperCI_Kismet_Baby_vs_Kismet.upper;
           upperCI_Baby_Kismet_vs_Baby.upper];

cases = ["Kismet vs Kismet", ...
         "Baby vs Baby", ...
         "Kismet vs Baby", ...
         "Baby vs Kismet", ...
         "Kismet & Baby vs Kismet", ...
         "Baby & Kismet vs Baby"];

x = 1:length(mean_accuracies);

% plot
figure
bar(x,mean_accuracies)
hold on
er = errorbar(x,mean_accuracies, mean_accuracies-lowerCI, upperCI-mean_accuracies);
er.Color = [0 0 0];
er.LineWidth = 1.5;
er.LineStyle = 'none';  
grid on
ylim([0 110])
xticklabels(cases)
xlabel('Approach')
ylabel('Accuracy [%]')
title('Mean accuracy and Confidence Interval (95%) for the 3-class prediction task')