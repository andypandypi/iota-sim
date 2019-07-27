function rwSite = random_walk(Tangle, alpha, beta)

% start random walk from max depth
maxDepthSites = find([Tangle.Sites.depth]>=Tangle.maxDepth);
if(isempty(maxDepthSites))
    rwSite = ceil(Tangle.nStartingTips*rand());
else
    rwSite = randsample(maxDepthSites,1);
end

while ~Tangle.Sites(rwSite).isTip
    children = [];
    % only valid parents if have completed PoW
    for c = Tangle.Sites(rwSite).children
        if Tangle.Sites(p).isAttached
            children = [children c];
        end
    end
    
    parents = Tangle.Sites(rwSite).parents;
        

    CW = Tangle.Sites(rwSite).cumulativeWeight(Tangle.nCW);
    dCWdt = Tangle.Sites(rwSite).dCWdt; %Tangle.lambda;
    childCWs = zeros(1,length(children));
    childdCWdts = zeros(1,length(parents));
    for j = 1:length(children)
        childCWs(j) = Tangle.Sites(children(j)).cumulativeWeight(Tangle.nCW);
        childdCWdts(j) = Tangle.Sites(children(j)).dCWdt;
    end
%% possibly dodgey
    if isempty(children)
        break % this is a tip
%%
    elseif isempty(parents)
        denA = exp(-alpha*(CW*ones(1, length(children))-childCWs));
        denB = exp(-beta*abs(dCWdt*ones(1, length(children))-childdCWdts));
        for j = 1:length(children)
            numA = exp(-alpha*(CW-childCWs(j)));
            numB = exp(-beta*abs(dCWdt-childdCWdts(j)));
            jumpingProbs(j) = numA.*numB/sum(denA.*denB);
        end
    else
        denA = exp(-alpha*(CW*ones(1, length(children))-childCWs));
        denB = exp(-beta*abs(dCWdt*ones(1, length(children))-childdCWdts));
        for j = 1:length(children)
            numA = exp(-alpha*(CW-childCWs(j)));
            numB = exp(-beta*abs(dCWdt-childdCWdts(j)));
            jumpingProbs(j) = (1-Tangle.q)*numA.*numB/sum(denA.*denB);
        end
        for j = length(children)+1:length(children)+length(parents)
            jumpingProbs(j) = Tangle.q*(1/length(parents));
        end
    end
    options = [children parents];
    probIntervals = [0 jumpingProbs];
    randRoll = rand();
    for j = 1:length(jumpingProbs)
        if randRoll>=sum(probIntervals(1:j)) && randRoll<=sum(probIntervals(1:j+1))
            rwSite = options(j);
            break
        end
    end
end

end