function [Tangle, Results] = generate_tangle(Tangle, mcNum, Results)


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
    
    % storing results (move this to a function)
    timeIndex = int32((t+Tangle.dt)/Tangle.dt);
    Results.allTips(mcNum, timeIndex) = sum([Tangle.Sites.isTip]);
    
end
close(f)