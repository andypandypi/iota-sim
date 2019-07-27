function Tangle = updatedepth(Tangle, currentSite, depth)

parents = Tangle.Sites(currentSite).parents;

if ~isempty(parents) % && Tangle.Sites(currentSite).depth<=Tangle.maxDepth
    % Update children depths and call function again for all children
    for i = 1:length(parents)
        % Update depth of this child
        if(Tangle.Sites(parents(i)).depth<depth)
            Tangle.Sites(parents(i)).depth = depth;
            % Call self on this child
            Tangle = updatedepth(Tangle, parents(i), depth+1);
        end
    end
end