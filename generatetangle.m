function [Results] = generatetangle(Tangle, mcNum, Results, varargin)

%% Tangle Simulation

% Create waitbar
f = waitbar(0, num2str(mcNum),'Name','Tangle Iteration Completion Bar',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'', 1)');

setappdata(f,'canceling',0);

% begin malicious transaction type at 2
iType = 2;

for t = 0:Tangle.dt:Tangle.endTime-Tangle.dt
    % Update waitbar
    if getappdata(f,'canceling')
        break
    end
    waitbar(t/Tangle.endTime,f)
    
    % snapshot of the tangle before making changes in this time step
    
    timeIndex = int32((t+Tangle.dt)/Tangle.dt);
    Results.allTips(mcNum, timeIndex) = sum([Tangle.Sites.isTip]);
    Results.allHonTips(mcNum, timeIndex) = sum([Tangle.Sites.isTip].*([Tangle.Sites.type]==1));
    Results.freeTips(mcNum, timeIndex) = sum([Tangle.Sites(:).isTip].*~[Tangle.Sites(:).isSelected]);
    Results.freeHonTips(mcNum, timeIndex) = sum([Tangle.Sites(:).isTip].*~[Tangle.Sites(:).isSelected].*([Tangle.Sites.type]==1));
    Results.dishonTips(mcNum, timeIndex) = sum([Tangle.Sites.type]~=1);
    
    pendingTimes = [Tangle.Sites.isTip].*[Tangle.Sites.timePending].*([Tangle.Sites.type]==1);
    pendingTimes(pendingTimes==0) = [];
    Results.avgTimePending(mcNum, timeIndex) = mean(pendingTimes);
    Results.maxTimePending(mcNum, timeIndex) = max(pendingTimes);
    Results.varTimePending(mcNum, timeIndex) = var(pendingTimes);
    
    % add new arrivals for this time step
    if(max([Tangle.Sites.depth])<=Tangle.maxDepth)
        [Tangle, ~] = newarrivals(Tangle, Tangle.lambda, 0, 0);
    else
        [Tangle, iType] = newarrivals(Tangle, Tangle.lambda, Tangle.mu, iType);
    end
    for i = 1:Tangle.size
        % set new CW as unchanged to begin with
        Tangle.Sites(i).cumulativeWeight = [Tangle.Sites(i).cumulativeWeight(2:Tangle.nCW) Tangle.Sites(i).cumulativeWeight(Tangle.nCW)];
        % if this site is not yet added to the tangle (pending)
        if ~Tangle.Sites(i).isTip && ~Tangle.Sites(i).isSelected
            
            % if the site has found suitable tips to validate - PoW in
            % progress
            if Tangle.Sites(i).selectedParents
                % do PoW
                Tangle = doPoW(Tangle, i);
                if Tangle.Sites(i).isAttached
                    continue
                end
            % else look for some tips to validate
            else
                Tangle = selecttips(Tangle, i, varargin{:});
                
                Tangle.Sites(i).timePending = Tangle.Sites(i).timePending + Tangle.dt;
            end
            
        % else, this has been added to the tangle so increment its age and
        % check if it has been orphaned.
        else
            Tangle.Sites(i).age = Tangle.Sites(i).age + Tangle.dt;
            
%             if Tangle.Sites(i).isTip
%                 maxDepth = max([Tangle.Sites.depth]);
%                 if(maxDepth>Tangle.maxDepth)
%                     maxDepth = Tangle.maxDepth;
%                 end
%                 [Tangle, hasMCMCPath] = findorphans(Tangle, i, maxDepth);
%                 Tangle.Sites(i).isOrphan = ~hasMCMCPath;
%             end
            
        end        
    end
    
end
Results.FinalTangles(mcNum) = Tangle;
close(f);
delete(f);

