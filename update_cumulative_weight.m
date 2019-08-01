function Tangle = update_cumulative_weight(Tangle, currentSite, newTip, newTipWeight)

parents = Tangle.Sites(currentSite).parents;

if ~isempty(parents) % && Tangle.Sites(currentSite).depth<=Tangle.maxDepth
    % Update parents weights and call function again for all parents
    for p = parents
        % only update this parent and its parents if it has not already
        % been touched on this time step and is valid
        if Tangle.Sites(p).lastTipAdded==newTip
            continue
        else
            % Update weight of this parents
            Tangle.Sites(p).cumulativeWeight(Tangle.nCW) = Tangle.Sites(p).cumulativeWeight(Tangle.nCW) + newTipWeight;
            Tangle.Sites(p).lastTipAdded = newTip;
            
            % Call self on this parent
            Tangle = update_cumulative_weight(Tangle, p, newTip, newTipWeight);
            
        end
    end
else
    return
end

end