function Tangle = add_edges(Tangle, newSite, selectedTips)
% ADD_EDGES adds edges linking selected tips to a newly arrived site
%
%   newSite inherits the type of selectedTips

% exception for the genesis to avoid duplicate
if(selectedTips(1)==1) % the genesis
    selectedTips = selectedTips(1);
end

% Update the tangle to include this new valid selection
Tangle.Sites(newSite).parents = selectedTips;
Tangle.Sites(newSite).selectedParents = 1;
% new site inherits the type of its parents
dsTips = find([Tangle.Sites(selectedTips).type]);
if(isempty(dsTips))
    Tangle.Sites(newSite).type = 0;
else
    Tangle.Sites(newSite).type = Tangle.Sites(selectedTips(dsTips(1))).type;
end

for i = 1:length(selectedTips)
    Tangle.Sites(selectedTips(i)).isSelected = 1;
    Tangle.Sites(selectedTips(i)).children = [Tangle.Sites(selectedTips(i)).children newSite];
end