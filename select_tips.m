function Tangle = select_tips(Tangle, currentTip, varargin) % this syntax allows an optimisation which means Tangle is not copied
% This function selects tips to attach to
% 'currentTip' is the arriving tip
% if varargin is empty, RS will be used
% varargin should contain alpha1, beta1, alpha2, beta2, ...

nSelected = 0;
i = 1;

if(nargin<=2)
%% Uniform Random Tip Selection
    selectedTips = zeros(1, 2);
    while i<=2
        tip = uniform_random_tip_selection(Tangle);

        selectedTips(nSelected+1) = tip;
        i = i + 1; % move to next tip selection
        nSelected = nSelected + 1;
    end

else 
%% Random Walk Tip Selection
    selectedTips = zeros(1, (nargin-2)/2);
    while i <= nargin-2 % for all tip selections in argument list
        alpha = varargin{i};
        beta = varargin{i+1};

        rwSite = random_walk(Tangle, alpha, beta);

        selectedTips(nSelected+1) = rwSite;
        i = i + 2;
        nSelected = nSelected + 1;
    end
end


% check if selected tips are valid and exit if not
[isValid,selectedTips] = is_valid_tip_selection(Tangle, selectedTips);
if(~isValid)
    return
end

% Update the tangle to include this new valid selection
Tangle.Sites(currentTip).parents = selectedTips;
Tangle.Sites(currentTip).selectedParents = 1;
for i = 1:length(selectedTips)
    Tangle.Sites(selectedTips(i)).isSelected = 1;
    Tangle.Sites(selectedTips(i)).children = [Tangle.Sites(selectedTips(i)).children currentTip];
end
end