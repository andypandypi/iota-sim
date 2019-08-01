function [isValid, selectedTips] = is_valid_tip_selection(Tangle, selectedTips)
% IS_VALID_TIP_SELECTION checks that selectedTips are compatible.
%
%   [isValid, selectedTips] = IS_VALID_TIP_SELECTION(Tangle, selectedTips)
%   checks that all selected tips are of the same type and that no tip is
%   selected more that once.
%
%   selectedTips is trimmed to exclude tips that have been selected more
%   than once.

isValid = true;
if(range([Tangle.Sites(selectedTips).type])>0 || range(selectedTips)==0)
    if(length(selectedTips)>2)
        selectedTips = selectedTips(1:2);
        if(range([Tangle.Sites(selectedTips).type])>0 || range(selectedTips)==0)
            isValid = false;
        end
    else
        if(selectedTips(1)==1) % the genesis
            selectedTips = selectedTips(1);
        else
            isValid = false;
        end
        
    end
end