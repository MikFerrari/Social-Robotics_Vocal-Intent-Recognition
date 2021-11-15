function [meanAcc, lower, upper] = bootstrap_noPlot(feat_test, model,nboot)
    sample_size = round(height(feat_test)/10);
    bootstat = table();
    accuracies = [];
    
    for i = 1:nboot
        feat_test_shuffled = feat_test(randperm(size(feat_test,1)),:);
        selectedData = feat_test_shuffled(1:sample_size,:);
        sim_result = simulateTest_1step(selectedData,model);
        bootstat = [bootstat; sim_result];
        
        accuracy = sum(sim_result.actual == sim_result.predicted)/numel(sim_result.actual)*100;
        accuracies = [accuracies accuracy];
    end
    
    actual = bootstat.actual;
    pred = bootstat.predicted;
    
    % Compute Confidence Interval (95%)
    accuracies = sort(accuracies,'ascend');
    alpha = 0.95;
    p = ((1.0-alpha)/2.0)*100;
    lower = max(0.0,prctile(accuracies, p));
    p = (alpha+((1.0-alpha)/2.0))*100;
    upper = min(100.0,prctile(accuracies, p));
    
    meanAcc = mean(accuracies);
    
    
%     % Display Accuracy Results
%     disp(['Mean accuracy: ' + string(mean(accuracies)) + ' %'])
%     disp(['Confidence Interval: [' + string(lower) + ', ' + string(upper) + ']'])
%     
%     figure
%     histogram(accuracies,10); % nbins
%     title('Accuracy Single-Step Classification')
%     xlabel('Accuracy')
%     ylabel('N° of simulations')
%     hold on
%     ax = gca;
%     xline(mean(accuracies),'-','mean','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)
%     xline(lower,'-','2.5 percentile','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)
%     xline(upper,'-','97.5 percentile','LabelVerticalAlignment','middle','LabelHorizontalAlignment','center','Color',[1 0 0],'LineWidth',2)

end


function result = simulateTest_1step(data,trainedModel)
    predicted = trainedModel.predictFcn(data);
    
    test_results = addvars(data,predicted);
    test_results = sortrows(test_results,'label');
    
    result = table(test_results.label,test_results.predicted);
    result.Properties.VariableNames = {'actual','predicted'};
end