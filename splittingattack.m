% Example script for generating a Tangle for several monte carlo simulations
clear all
close all
%% Initialise Tangle simulation parameters
nMC = 1;           % number of monte carlos
Tangle.nNodes = 1;
Tangle.simTime = 180;
Tangle.q = 1/3;
Tangle.dt = 0.1;    % must be inverse of a whole number
Tangle.mu = 0;      % rate of malicious arrivals
Tangle.nCW = 1;     % store this many past values of CW
Tangle.h = 1;
Tangle.maxDepth = 2000;
Tangle.nStartingTips = 1;
Tangle.size = Tangle.nStartingTips;

%% Node parameters
alpha = 0.01;
beta = 0;
lambda = 18;
tsa = @standard_tsa;
Tangle.Nodes(1) = new_node(alpha, beta, [], [], lambda, tsa);

mu = 2;
tsa = @splitting_tsa;
Tangle.Nodes(2) = new_node([],[],[],[], mu, tsa);

%% Initialise results structure
Results.allTips = zeros(nMC, Tangle.simTime/Tangle.dt);
Results.type0Tips = zeros(nMC, Tangle.simTime/Tangle.dt);
Results.type1Tips = zeros(nMC, Tangle.simTime/Tangle.dt);
Results.type2Tips = zeros(nMC, Tangle.simTime/Tangle.dt);
Results.ds1cw = zeros(nMC, Tangle.simTime/Tangle.dt);
Results.ds2cw = zeros(nMC, Tangle.simTime/Tangle.dt);

%% Monte carlo simulations

for mcNum = 1:nMC
    NewTangle = Tangle;
    [NewTangle, Results] = generate_tangle_ds(NewTangle, mcNum, Results);
end

%% Plot results
time = 0:Tangle.dt:Tangle.simTime-Tangle.dt;
IEEEFigure
figure(1);
hold on
for mcNum = 1:nMC
    plot(time, Results.type0Tips(mcNum, :), 'b');
    plot(time, Results.type1Tips(mcNum, :), 'r');
    plot(time, Results.type2Tips(mcNum, :), 'g');
end
legend('type 0', 'type 1', 'type 2');

figure(2)
hold on
for mcNum = 1:nMC
    plot(time, Results.ds1cw(mcNum, :), 'b');
    plot(time, Results.ds2cw(mcNum, :), 'r');
end
