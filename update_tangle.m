function Tangle = update_tangle(Tangle)

newSites = find(~[Tangle.Sites.isTip].*~[Tangle.Sites.isSelected].*~[Tangle.Sites.selectedParents]);
pendingSites = find(~[Tangle.Sites.isTip].*~[Tangle.Sites.isSelected].*[Tangle.Sites.selectedParents]);
addedSites = find(~(~[Tangle.Sites.isTip].*~[Tangle.Sites.isSelected]));

% look for tips to validate for newly arrived sites
for i = newSites 
    n = Tangle.Sites(i).node;
    Tangle = selecttips(Tangle, i, Tangle.Nodes(n).alpha, Tangle.Nodes(n).beta, Tangle.Nodes(n).alpha, Tangle.Nodes(n).beta);
    Tangle.Sites(i).timePending = Tangle.Sites(i).timePending + Tangle.dt;
end

% do PoW for pending sites
for i = pendingSites 
    Tangle = doPoW(Tangle, i);
    if Tangle.Sites(i).isAttached
        continue
    end
end

% increment age of fully added sites
for i = addedSites
    Tangle.Sites(i).age = Tangle.Sites(i).age + Tangle.dt;
end