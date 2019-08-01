function rwSite = random_walk(Tangle, alpha, beta, lastSelection, type)

% start random walk from genesis
if(max([Tangle.Sites.depth])<Tangle.maxDepth)
    rwSite = 1;
else
    rwSite = randsample(find([Tangle.Sites.depth]>=Tangle.maxDepth), 1);
end

while (~Tangle.Sites(rwSite).isTip)
    
%     if(~is_valid_site(rwSite))
%         % restart random walk
%         if(max([Tangle.Sites.depth])<Tangle.maxDepth)
%             rwSite = 1;
%             if(sum([Tangle.Sites.isTip])==1) % case when there is only one tip so far
%                 break
%             end
%         else
%             rwSite = randsample(find([Tangle.Sites.depth]>=Tangle.maxDepth), 1);
%         end
%     end
    children = [];
    % only valid child if have completed PoW and are consistent with last
    % selection type
    for c = Tangle.Sites(rwSite).children
        if Tangle.Sites(c).isAttached && is_valid_site(Tangle, c, type, lastSelection)
            children = [children c];
        end
    end
    
    parents = Tangle.Sites(rwSite).parents;
    
    jumpingProbs = zeros(1, length(children) + length(parents));
    CW = Tangle.Sites(rwSite).cumulativeWeight(Tangle.nCW);
    dCWdt = Tangle.Sites(rwSite).dCWdt; %Tangle.lambda;
    childCWs = zeros(1,length(children));
    childdCWdts = zeros(1,length(parents));
    for j = 1:length(children)
        childCWs(j) = Tangle.Sites(children(j)).cumulativeWeight(Tangle.nCW);
        childdCWdts(j) = Tangle.Sites(children(j)).dCWdt;
    end
%% possibly missin a case of no children
    if isempty(children)
        jumpingProbs = ones(1, length(parents))/length(parents);
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
%             nextSiteType = Tangle.Sites(options(j)).type;
%             if(isempty(lastSelection))
%                 rwSite = options(j);
%             elseif((nextSiteType==0 || nextSiteType==type) && options(j)~=lastSelection)
%                 rwSite = options(j);
%             else
%                 return
%             end
%             break
            rwSite = options(j);
        end
    end
end

end

function isValid = is_valid_site(Tangle, rwSite, type, lastSelection)
if(rwSite==lastSelection)
    isValid = false;    
elseif(Tangle.Sites(rwSite).type==0)
    isValid = true;
elseif(Tangle.Sites(rwSite).type==type || type==0)
    isValid = true;
else
    isValid = false;
end
end