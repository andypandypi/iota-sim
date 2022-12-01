% Example script for generating a Tangle for several monte carlo simulations

%% Initialise Tangle simulation parameters
nMC = 1;           % number of monte carlos
Tangle.nNodes = 1;
Tangle.simTime = 120;
Tangle.q = 1/3;
Tangle.dt = 0.1;    % must be inverse of a whole number
Tangle.mu = 0;      % rate of malicious arrivals
Tangle.nCW = 1;     % store this many past values of CW
Tangle.h = 1;
Tangle.maxDepth = 20;
Tangle.nStartingTips = 1;
Tangle.size = Tangle.nStartingTips;

%% Node parameters
alpha = [];
beta = [];
lambda = 20;
tsa = @standard_tsa;
Tangle.Nodes = new_node(alpha, beta, 0, 0, lambda, tsa);

%% Initialise results structure
Results.allTips = zeros(nMC, Tangle.simTime/Tangle.dt);

%% Monte carlo simulations

for mcNum = 1:nMC
    NewTangle = Tangle;
    [NewTangle, Results] = generate_tangle(NewTangle, mcNum, Results);
end

%% Plot results
time = 0:Tangle.dt:Tangle.simTime-Tangle.dt;
figure(1);
hold on
for mcNum = 1:nMC
    plot(time, Results.allTips(mcNum, :), 'b');
end
