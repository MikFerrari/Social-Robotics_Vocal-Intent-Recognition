info = whos('net');
disp("Network size: " + info.bytes/1024 + " kB")

nRuns = 100;
sample_size = round(height(features_test)/5);

time = zeros(nRuns,1);
accuracies = zeros(nRuns,1);

for i = 1:nRuns
    idx = randperm(size(features_test,4));
    idx = idx(1:sample_size);
    selected_features = features_test(:,:,:,idx);
    selected_labels = labels_test(idx);

    tic
    predicted_labels = classify(net,selected_features,"ExecutionEnvironment","cpu");
    accuracy = (sum(predicted_labels == selected_labels))/length(selected_labels)*100;
    time(i) = toc;

    accuracies(i) = accuracy;
end

disp("Single-sample prediction time on CPU: " + mean(time(11:end))*1000 + " ms")

accuracies = sort(accuracies,'ascend');
alpha = 0.95;
p = ((1.0-alpha)/2.0)*100;
lower = max(0.0,prctile(accuracies, p));
p = (alpha+((1.0-alpha)/2.0))*100;
upper = min(100.0,prctile(accuracies, p));

mean_accuracy = mean(accuracies);

% Display Accuracy Results
disp(['Mean accuracy: ' + string(mean(accuracies)) + ' %'])
disp(['Confidence Interval: [' + string(lower) + ', ' + string(upper) + ']'])

figure
histogram(accuracies,20); % nbins
title('Accuracy Single-Step Classification')
xlabel('Accuracy')
ylabel('N° of simulations')
hold on
ax = gca;
xline(mean(accuracies),'-','mean','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)
xline(lower,'-','2.5 percentile','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)
xline(upper,'-','97.5 percentile','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)


save(strcat('.\evaluation_metrics\accuracy_',task_selection,'.mat'),'mean_accuracy')
save(strcat('.\evaluation_metrics\lowerCI_',task_selection,'.mat'),'lower')
save(strcat('.\evaluation_metrics\upperCI_',task_selection,'.mat'),'upper')