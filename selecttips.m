% This function selects tips to attach to
% 'currentTip' is the arriving tip
% if varargin is empty, RS will be used
% varargin should contain alpha1, beta1, alpha2, beta2, ...
function Tangle = selecttips(Tangle, currentTip, varargin) % this syntax allows an optimisation which means Tangle is not copied

nSelected = 0;
i = 1;
if(nargin<=2)
    selectedTips = zeros(1, 2);
    while i<=2
        % Random Selection for this tip as not specified in args
        tipSet = [Tangle.Sites(:).isTip];
        tipIndices = find(tipSet);
        nTips = length(tipIndices);
        iTip = ceil(nTips*rand());
        selectedTips(nSelected+1) = tipIndices(iTip);
        i = i + 1; % move to next tip selection
        nSelected = nSelected + 1;
    end
else
    selectedTips = zeros(1, (nargin-2)/2);
    while i <= nargin-2 % for all tip selections in argument list
        alpha = varargin{i};
        beta = varargin{i+1};

        mcmcSite = runmcmc(Tangle, alpha, beta);

        selectedTips(nSelected+1) = mcmcSite;
        i = i + 2;
        nSelected = nSelected + 1;
    end
end



% check if selected tips are valid and exit if not
if(range([Tangle.Sites(selectedTips).type])>0 || range(selectedTips)==0)
    if(nSelected>2)
        selectedTips = selectedTips(1:2);
        nSelected = 2;
        if(range([Tangle.Sites(selectedTips).type])>0 || range(selectedTips)==0)
            return
        end
    else
        return
    end
end

% Update the tangle to include this new valid selection
Tangle.Sites(currentTip).parents = selectedTips;
Tangle.Sites(currentTip).selectedParents = 1;
for i = 1:nSelected
    Tangle.Sites(selectedTips(i)).isSelected = 1;
    Tangle.Sites(selectedTips(i)).children = [Tangle.Sites(selectedTips(i)).children currentTip];
end
end