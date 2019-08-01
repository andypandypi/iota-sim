function tip = uniform_random_tip_selection(Tangle)
selectedTips = zeros(1,2);

l0 = find([Tangle.Sites.isTip].*([Tangle.Sites.type]==0));
l1 = find([Tangle.Sites.isTip].*([Tangle.Sites.type]==1));
l2 = find([Tangle.Sites.isTip].*([Tangle.Sites.type]==2));

if(isempty(l1) || isempty(l2))
    if(isempty(l0))
        selectedTips = 1;
    elseif(length(l0)==1)
        selectedTips = [1 l0];
    else
        selectedTips = randsample(l0, 2);
    end
end

tipIndices = find([Tangle.Sites(:).isTip]);
nTips = length(tipIndices);
if(nTips==0)
    tip = 1;
else
    iTip = ceil(nTips*rand());
    tip = tipIndices(iTip);
end