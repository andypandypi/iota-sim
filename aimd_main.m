function aimd_main(simTime, lambda, nNodes, orphanAge, orphanRate, alpha_AIMD, beta_AIMD)

% create global variable by adding them to Tangle structure
Tangle.nNodes = nNodes;
Tangle.orphanAge = orphanAge;
Tangle.orphanRate = orphanRate;
Tangle.bAvgFilt = (1/10)*ones(10,1);
Tangle.simTime = simTime;
Tangle.q = 1/3;
Tangle.dt = 0.1;    % must be inverse of a whole number
Tangle.mu = 0;      % rate of malicious arrivals
Tangle.nCW = 1;     % store this many past values of CW
Tangle.h = 1;
Tangle.maxDepth = 20;
Tangle.nStartingTips = 1;
Tangle.size = Tangle.nStartingTips;

% create a vector of lambdas if it was given as a constant
if(length(lambda)==1)
    Tangle.lambda = lambda*ones(1, simTime/Tangle.dt); % rate of honest arrivals
elseif(length(lambda)==simTime/Tangle.dt)
    Tangle.lambda = lambda;
else
    error('lambda input is incorrect length');
end

% create the genesis transaction
Tangle = create_genesis(Tangle);

for n = 1:Tangle.nNodes
    Tangle.Nodes(n).alpha = 0.1;
    Tangle.Nodes(n).beta = 0;
    Tangle.Nodes(n).alpha_AIMD = alpha_AIMD;
    Tangle.Nodes(n).beta_AIMD = beta_AIMD;
end

Results.alphas = zeros(nNodes, simTime);
Results.orphanRate = zeros(nNodes, simTime);
Results.avgOrphanRate = zeros(nNodes, simTime);
Results.nOrphans = zeros(nNodes, simTime);

Results.nTips = zeros(1, simTime/Tangle.dt);

[~, Results] = generate_aimd(Tangle, 1, Results);

%% Plotting of results
% save('Results_basic.mat', 'Results'); 

close all
IEEEFigure

figure(1)
hold on
c = get(groot,'DefaultAxesColorOrder');
for i = 1:size(Results.alphas,1)
    plot(1:size(Results.alphas,2), Results.alphas(i,:), 'Color', c(i,:));
    plot([0 size(Results.alphas,2)], [mean(Results.alphas(i,:)) mean(Results.alphas(i,:))], 'Color', c(i,:), 'LineStyle', '--');
end

ylabel('$\alpha$','Interpreter', 'latex');
xlabel('Time(s)');

figure(2)
hold on
c = get(groot,'DefaultAxesColorOrder');
for i = 1:size(Results.alphas,1)
    plot(1:Tangle.simTime, Results.avgOrphanRate(i,:), 'Color', c(i,:));
end

ylabel('Orphan Rate (moving average)','Interpreter', 'latex');
xlabel('Time(s)');

end
