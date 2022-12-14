%%%------------- Hierarchical Clustering
% Step 1: Consider each data point as a single cluster.
% Step 2: Combine the two closest clusters and make them one cluster.
% Step 3: Repeatedly combine clusters until there is only one cluster.

% Approaches for finding closest clusters
% Single Link: Min distance
% Complete Link: Max distance
% Average: Average distance

% Types of Hierachical Clustering : Agglomerative, Divisive

% Import the dataset
data = readtable('Datasets\Mall_Customers.csv');

%Check for missing values
missings = sum(ismissing(data));

%Plot variables to check for outliers
IncomePlot = plot(data.AnnualIncome);
SpendingPlot = plot(data.SpendingScore);

% Perform Feature Scaling (Standardization Method)
stand_income = (data.AnnualIncome - mean(data.AnnualIncome)) / std(data.AnnualIncome);
data.AnnualIncome = stand_income; 

stand_spending = (data.SpendingScore - mean(data.SpendingScore)) / std(data.SpendingScore);
data.SpendingScore = stand_spending; 

% Select columns for clustering
selected_data = data(:,4:5);

%Data must be an array to be used in clustering algorithm
arrayed_data = table2array(selected_data);

% Select linkage method
z = linkage(arrayed_data, 'ward');

% Create dendogram
dendrogram(z);

% Determining tresholds for optimal number of clusters using links
% inconsistencies
i = inconsistent(z,7); % 7 is the deepest link depth
% i produces 4 column 
% Col1 represents average height of all links in calculation
% Col2 represents standard deviation of all links in calculation
% Col3 represents number of links included in calculation
% Col4 represents inconsistency score
[a,b]= max(i(:,4)); % max inconsistency score and save it in a and its index in b

% Perform clustering
% Set treshold as little less than the max inconsistent element.With cutoff
% method (heights)
C= cluster(z,'cutoff', z(b,3)-0.1, 'Criterion', 'distance');


%------- Visualization
data = arrayed_data;
figure,

gscatter(data(:,1),data(:,2),C);
hold on

legend({'Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Cluster 5' })
xlabel('Annual Income');
ylabel('Spending Score');
hold off
