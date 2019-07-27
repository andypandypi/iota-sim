function Tangle = generate_sites(Tangle, lambda, mu, muType, node)

%% Honest arrivals
nNewHon = poissrnd(lambda*Tangle.dt);
% create this many new honest transactions
if nNewHon>0
    
    for i = 1:nNewHon
        [depth, oldSite] = max([Tangle.Sites.depth]);
        if(depth<=Tangle.maxDepth)
            Tangle.Sites(Tangle.size + 1) = new_site(1, 1, Tangle.nCW, node);
            Tangle.size = Tangle.size + 1;
        else
            % remove references to old side
            children = Tangle.Sites(oldSite).children;
            for c = children
                Tangle.Sites(c).parents(Tangle.Sites(c).parents==oldSite) = [];
            end
            
            Tangle.Sites(oldSite) = new_site(1, 1, Tangle.nCW, node);
        end
    end
end

%% Dishonest arrivals
nNewDishon = poissrnd(mu*Tangle.dt);
% create this many new honest transactions
if nNewDishon>0
    
    for i = 1:nNewDishon
        [depth, oldSite] = max([Tangle.Sites.depth]);
        if(depth<=Tangle.maxDepth)
            Tangle.Sites(Tangle.size + 1) = new_site(muType, 1, Tangle.nCW, node);
            Tangle.size = Tangle.size + 1;
        else
            % remove references to old side
            children = Tangle.Sites(oldSite).children;
            for c = children
                Tangle.Sites(c).parents(Tangle.Sites(c).parents==oldSite) = [];
            end
            
            Tangle.Sites(oldSite) = new_site(muType, 1, Tangle.nCW, node);
        end
    end
end


end
