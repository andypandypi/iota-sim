function Tangle = generate_sites(Tangle, lambda, mu, type, node)

% number of new honest arrivals in this time step according to poisson
nNewHon = poissrnd(lambda*Tangle.dt);
% create this many new honest transactions
if nNewHon>0
    
    for i = 1:nNewHon
        [depth, oldSite] = max([Tangle.Sites.depth]);
        if(depth<=Tangle.maxDepth)
            Tangle.Sites(Tangle.size + 1) = newsite(type, 1, Tangle.nCW, node);
            Tangle.size = Tangle.size + 1;
        else
            % remove references to old side
            children = Tangle.Sites(oldSite).children;
            for c = children
                Tangle.Sites(c).parents(Tangle.Sites(c).parents==oldSite) = [];
            end
            
            Tangle.Sites(oldSite) = newsite(type, 1, Tangle.nCW, node);
        end
    end
end

%% Parasite chain part

if mu>0
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
end

end
