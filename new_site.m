function [Site] = new_site(weight, nCW, node)
CW = weight*ones(1,nCW);
Site = struct('selectedParents', false, 'age', 0, 'timePending', 0, 'timeAsTip', 0, 'children', [], 'parents', [], 'type', 0, 'poWDone', 0, 'computingPower', 1, 'isTip', false, 'isAttached', false, 'isSelected', false, 'isOrphan', false, 'weight', weight, 'cumulativeWeight', CW, 'dCWdt', 0, 'depth', 0, 'lastTipAdded', 0, 'lastCheck', 0, 'node', node);

end
