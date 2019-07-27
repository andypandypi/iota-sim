function Tangle = generate_parasite_chain(Tangle, mu)

% number of new PC arrivals in this time step according to poisson
nNewPC = poissrnd(mu*Tangle.dt);
% create this many new PC transactions
if nNewPC>0
    pcTips = find([Tangle.Sites.type]==2.*[Tangle.Sites.isTip]);
    if(length(pcTips)>1)
        pcTip = randsample(pcTips, 1);
    else
        pcTip = pcTips;
    end

    for i = 1:nNewPC
        nextPCSite = Tangle.size + 1;
        Tangle.size = Tangle.size + 1;
        Tangle.Sites(nextPCSite) = newpcsite(2, 1, Tangle.nCW);
        Tangle.Sites(pcTip).children = [Tangle.Sites(pcTip).children nextPCSite];
        Tangle.Sites(nextPCSite).parents = pcTip;
        Tangle.Sites(nextPCSite).isTip = true;
        Tangle.Sites(nextPCSite).isSelected = true;
        Tangle.Sites(nextPCSite).isAttached = true;
        Tangle.Sites(pcTip).isTip = false;
        Tangle = updatecumulativeweight(Tangle, nextPCSite,nextPCSite,Tangle.Sites(nextPCSite).weight);
        Tangle = updatedepth(Tangle, nextPCSite, 1);
    end
end