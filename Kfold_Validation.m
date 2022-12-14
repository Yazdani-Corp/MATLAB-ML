%---------------------Validation Methods------------------------

data = readtable('Datasets\Social_Network_Ads.csv');

%--------Preprocess
sum(ismissing(data)); % Count of missing values in columns

% Check for the outliers with plotting
% plot(data.Age);
% plot(data.EstimatedSalary)

% Feature Scaling with Standardization
stand_age = (data.Age - mean(data.Age)) / std(data.Age);
data.Age = stand_age;

stand_estimatedsalary = (data.EstimatedSalary - mean(data.EstimatedSalary)) / std(data.EstimatedSalary);
data.EstimatedSalary = stand_estimatedsalary;

%-----------Classifying data
classification_model = fitcknn(data, 'Purchased~Age+EstimatedSalary'); %Classification Model
classification_model.NumNeighbors = 5; %Change number of neighbours.
%classification_model.NumNeighbors = 3; % Change the neighbor number to get better result
%classification_model = fitcknn(standardized_data, 'Survived~Age+Fare+Parch+SibSp+female+male+Pclass','NumNeighbors', 3);
%classification_model = fitcknn(standardized_data, 'Survived~Age+Fare+Parch+SibSp+female+male+Pclass','Distance', 'seuclidean');


%-----------Divide data into training and testing sets
%Numberof observations, classification models, percentage. Randomly choose
%0.2 percentage for testing.

%Validation with Holdout and Kfold
%cv = cvpartition(classification_model.NumObservations,'HoldOut', 0.2); 

cv = cvpartition(classification_model.NumObservations,'KFold', 5); %Produce 5 classifiers
cross_validated_model = crossval(classification_model, 'cvpartition', cv); %Use training set only to built model 

%-----------Make predictions for the each testing set
Predictions_K1 = predict(cross_validated_model.Trained{1}, data(test(cv,1),1:end-1));
Predictions_K2 = predict(cross_validated_model.Trained{2}, data(test(cv,2),1:end-1));
Predictions_K3 = predict(cross_validated_model.Trained{3}, data(test(cv,3),1:end-1));
Predictions_K4 = predict(cross_validated_model.Trained{4}, data(test(cv,4),1:end-1));
Predictions_K5 = predict(cross_validated_model.Trained{5}, data(test(cv,5),1:end-1));

%Alternative Way (Does not display individual results, which result belongs to which line)
Predictions = kfoldPredict(cross_validated_model); %Make predictions for 5 experiments

%-----------Analyzing the predictions
    %Confusion Matrix for each test results
Results_K1 = confusionmat(cross_validated_model.Y(test(cv,1)),Predictions_K1); 
Results_K2 = confusionmat(cross_validated_model.Y(test(cv,2)),Predictions_K2); 
Results_K3 = confusionmat(cross_validated_model.Y(test(cv,3)),Predictions_K3); 
Results_K4 = confusionmat(cross_validated_model.Y(test(cv,4)),Predictions_K4); 
Results_K5 = confusionmat(cross_validated_model.Y(test(cv,5)),Predictions_K5); 
% %data.Purchased(test(cv));

% %Combine results in  one confusion matrix
Results_K = Results_K1 + Results_K2 + Results_K3 + Results_K4 + Results_K5;

%Alternate Way
Results = confusionmat(table2cell(data(:,end)),Predictions);

%Producce confusion matrix stats for two categories. Not Purchased and
%Purchased in this example
Evaluation_results = confusionmatStats(table2cell(data(:,end)), Predictions);
