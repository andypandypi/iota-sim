function [Tangle, Results] = generate_tangle_ds(Tangle, mcNum, Results)

dsTime = 60;
Tangle.doubleSpend = [];
% Create waitbar
f = waitbar(0, num2str(mcNum),'Name','Tangle Iteration Completion Bar',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'', 1)');

setappdata(f,'canceling',0);

% Create the genesis site
Tangle = create_genesis(Tangle);

for t = 0:Tangle.dt:Tangle.simTime-Tangle.dt
    
    % Update waitbar
    if getappdata(f,'canceling')
        break
    end
    waitbar(t/Tangle.simTime,f)
    
    % Generate new sites
    Tangle = generate_sites(Tangle);
    
    % Update tangle
    Tangle = update_tangle(Tangle);
    
    % Create double spend
    if(t==dsTime)
        Tangle.doubleSpend = randsample(find([Tangle.Sites.isTip].*~[Tangle.Sites.isSelected]), 2);
        Tangle.Sites(Tangle.doubleSpend(1)).type = 1;
        Tangle.Sites(Tangle.doubleSpend(2)).type = 2;
    end
    
    % storing results (move this to a function)
    timeIndex = int32((t+Tangle.dt)/Tangle.dt);
    Results.allTips(mcNum, timeIndex) = sum([Tangle.Sites.isTip]);
    Results.type0Tips(mcNum, timeIndex) = sum([Tangle.Sites.isTip].*([Tangle.Sites.type]==0));
    Results.type1Tips(mcNum, timeIndex) = sum([Tangle.Sites.isTip].*([Tangle.Sites.type]==1));
    Results.type2Tips(mcNum, timeIndex) = sum([Tangle.Sites.isTip].*([Tangle.Sites.type]==2));
    if(t>=dsTime)
        Results.ds1cw(mcNum, timeIndex) = Tangle.Sites(Tangle.doubleSpend(1)).cumulativeWeight;
        Results.ds2cw(mcNum, timeIndex) = Tangle.Sites(Tangle.doubleSpend(2)).cumulativeWeight;
    end
    
end
close(f)