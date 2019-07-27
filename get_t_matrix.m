function T = get_t_matrix(Tangle, alpha, beta)
T = zeros(Tangle.size);
for i = 1:Tangle.size
    if(Tangle.Sites(i).isTip)
        T(i,i)=1;
        continue
    else
        children = [];
        % only valid if children have completed PoW
        for c = Tangle.Sites(i).children
            if Tangle.Sites(c).isAttached
                children = [children c];
            end
        end
        % only step to parents less than max depth
        parents = Tangle.Sites(i).parents;

        CW = Tangle.Sites(i).cumulativeWeight(Tangle.nCW);
        dCWdt = Tangle.Sites(i).dCWdt; %Tangle.lambda;
        childCWs = zeros(1,length(children));
        childdCWdts = zeros(1,length(children));
        for j = 1:length(children)
            childCWs(j) = Tangle.Sites(children(j)).cumulativeWeight(Tangle.nCW);
            childdCWdts(j) = Tangle.Sites(children(j)).dCWdt;
        end

        if isempty(children)
            for j = 1:length(parents)
                T(i,parents(j)) = 1/length(parents);
            end
        elseif isempty(parents)
            denA = exp(-alpha*(CW*ones(1, length(children))-childCWs));
            denB = exp(-beta*abs(dCWdt*ones(1, length(children))-childdCWdts));
            for j = 1:length(children)
                numA = exp(-alpha*(CW-childCWs(j)));
                numB = exp(-beta*abs(dCWdt-childdCWdts(j)));
                T(i,children(j)) = numA.*numB/sum(denA.*denB);
            end
        else
            denA = exp(-alpha*(CW*ones(1, length(children))-childCWs));
            denB = exp(-beta*abs(dCWdt*ones(1, length(children))-childdCWdts));
            for j = 1:length(children)
                numA = exp(-alpha*(CW-childCWs(j)));
                numB = exp(-beta*abs(dCWdt-childdCWdts(j)));
                T(i,children(j)) = (1-Tangle.q)*numA.*numB/sum(denA.*denB);
            end
            for j = 1:length(parents)
               T(i,parents(j)) = Tangle.q*(1/length(parents));
            end
        end
    end
end

end
