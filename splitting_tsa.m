function selectedTips =  splitting_tsa(Tangle, ~)
% SPLITTING_TSA implements a splitting attack policy, adding to the smaller
% branch

selectedTips = zeros(1,2);

l0 = find([Tangle.Sites.isTip].*([Tangle.Sites.type]==0));
l1 = find([Tangle.Sites.isTip].*([Tangle.Sites.type]==1));
l2 = find([Tangle.Sites.isTip].*([Tangle.Sites.type]==2));

if(isempty(Tangle.doubleSpend))
    if(isempty(l0))
        selectedTips = 1;
    elseif(length(l0)==1)
        selectedTips = [1 l0];
    else
        selectedTips = randsample(l0, 2);
    end
else
    cw1 = Tangle.Sites(Tangle.doubleSpend(1)).cumulativeWeight;
    cw2 = Tangle.Sites(Tangle.doubleSpend(2)).cumulativeWeight;
    if(cw1<cw2) %(length(l1)<=length(l2))
        if(length(l1)==1)
            selectedTips(1) = l1;
        else
            selectedTips(1) = randsample(l1, 1);
        end
        l1(l1==selectedTips(1)) = [];
        selectedTips(2) = randsample([l1 l0], 1);
    else
        if(length(l2)==1)
            selectedTips(1) = l2;
        else
            selectedTips(1) = randsample(l2, 1);
        end
        l2(l2==selectedTips(1)) = [];
        selectedTips(2) = randsample([l2 l0], 1);
    end
end