function Tangle = generate_sites(Tangle)

for node = 1:length(Tangle.Nodes)
    lambda = Tangle.Nodes(node).lambda;
    nNewSites = poissrnd(lambda*Tangle.dt);
    % create this many new site
    if nNewSites>0

        for i = 1:nNewSites
            [depth, oldSite] = max([Tangle.Sites.depth]);
            if(depth<=Tangle.maxDepth)
                Tangle.Sites(Tangle.size + 1) = new_site(1, Tangle.nCW, node);
                Tangle.size = Tangle.size + 1;
            else
                % remove references to old side
                children = Tangle.Sites(oldSite).children;
                for c = children
                    Tangle.Sites(c).parents(Tangle.Sites(c).parents==oldSite) = [];
                end

                Tangle.Sites(oldSite) = new_site(1, Tangle.nCW, node);
            end
        end
    end
end

end
