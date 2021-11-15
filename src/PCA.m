function [Tsorted,coeff,latent,explained] = PCA(data,graph_title,N,features_name)
    % N = number of desired principal components
    % Specify features names as column array of strings
    
    [coeff,~,latent,~,explained] = pca(data','NumComponents',N);
    
    A = [];
    for i = 1:size(coeff,2)
        A(:,i) = abs(coeff(:,i)).*explained(i)/100;
    end
    
    S = sum(A,2);
    S = S/sum(S)*100;
    
    features_name = categorical(cellstr(features_name));
    T = table(features_name,S);
    Tsorted = sortrows(T,2,{'descend'});
    
    % Plot results
    T.features_name = reordercats(T.features_name,cellstr(T.features_name));
   
    figure
    bar(T.features_name,T.S)
    ax = gca;
    ax.TickLabelInterpreter = 'none';
    ylabel('Explained Variance [%]')
    title(graph_title)

end