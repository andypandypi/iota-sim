function [isValid, selectedTips] = is_valid_tip_selection(Tangle, selectedTips)
isValid = true;
if(range([Tangle.Sites(selectedTips).type])>0 || range(selectedTips)==0)
    if(length(selectedTips)>2)
        selectedTips = selectedTips(1:2);
        if(range([Tangle.Sites(selectedTips).type])>0 || range(selectedTips)==0)
            isValid = false;
        end
    else
        isValid = false;
    end
end