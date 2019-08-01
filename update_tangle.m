function Tangle = update_tangle(Tangle)

newSites = find(~[Tangle.Sites.isAttached].*~[Tangle.Sites.selectedParents]);
pendingSites = find(~[Tangle.Sites.isAttached].*[Tangle.Sites.selectedParents]);
addedSites = find([Tangle.Sites.isAttached]);

% look for tips to validate for newly arrived sites
for newSite = newSites
    if(newSite>1)
        n = Tangle.Sites(newSite).node;
        selectedTips = Tangle.Nodes(n).tsa(Tangle, newSite);
        Tangle = add_edges(Tangle, newSite, selectedTips);
        Tangle.Sites(newSite).timePending = Tangle.Sites(newSite).timePending + Tangle.dt;
    end
end

% do PoW for pending sites
for pendingSite = pendingSites 
    Tangle = do_pow(Tangle, pendingSite);
    if Tangle.Sites(pendingSite).isAttached
        continue
    end
end

% increment age of fully added sites
for addedSite = addedSites
    Tangle.Sites(addedSite).age = Tangle.Sites(addedSite).age + Tangle.dt;
end