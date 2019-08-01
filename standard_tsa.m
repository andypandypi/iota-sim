function selectedTips = standard_tsa(Tangle, newSite) % this syntax allows an optimisation which means Tangle is not copied
% STANDARD_TSA Selects tips using URTS or RW.
%
%   Tangle = STANDARD_TSA(Tangle, newSite) selects 2 tips by
%   UNIFORM_RANDOM_TIP_SELECTION.
%
%   Tangle = STANDARD_TSA(Tangle, newSite, alpha1, beta1, ..., alphaN,
%   betaN) selects N tips by RANDOM_WALK.
% 
%   If only one set of RW parameters given then two RWs with same
%   parameters are performed.

n = Tangle.Sites(newSite).node;
alpha = Tangle.Nodes(n).alpha;
beta = Tangle.Nodes(n).beta;
if(length(alpha)~=length(beta))
    error('alpha and beta must be the same length')
end
if(length(alpha)==1)
    alpha = [alpha alpha];
    beta = [beta beta];
end

tipSet = find([Tangle.Sites.isTip]);

if(isempty(alpha) && isempty(beta))
%% Uniform Random Tip Selection
% needs to be modified for splitting attack and different types possiblity
    selectedTips = zeros(1, 2);
    if(isempty(tipSet))
        selectedTips = 1;
    elseif(length(tipSet)==1)
        selectedTips = [1 tipSet];
    else
        while(1)
            selectedTips = randsample(tipSet, 2);
            if(Tangle.Sites(selectedTips(1)).type==0 || Tangle.Sites(selectedTips(2)).type==0 ||range([Tangle.Sites(selectedTips).type])==0)
                break
            end
        end
    end

else 
%% Random Walk Tip Selection
    if(isempty(tipSet))
        selectedTips = 1;
    elseif(length(tipSet)==1)
        selectedTips = [1 tipSet];
    else
        selectedTips = zeros(1, length(alpha));
        type = 0;
        lastSelection = 0;
        for i = 1:length(alpha)
            if(i>1)
                lastSelection = rwSite;
                type = Tangle.Sites(rwSite).type; % type is enforced by the first selection
            end
            rwSite = random_walk(Tangle, alpha(i), beta(i), lastSelection, type);
            selectedTips(i) = rwSite;
        end
    end
end


end