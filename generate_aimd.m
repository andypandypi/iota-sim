function [Tangle, Results] = generate_aimd(Tangle, mcNum, Results)

%% Tangle Simulation

% Create waitbar
f = waitbar(0, num2str(mcNum),'Name','Tangle Iteration Completion Bar',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'', 1)');

setappdata(f,'canceling',0);

for t = 0:Tangle.dt:Tangle.simTime-Tangle.dt
    % Update waitbar
    if getappdata(f,'canceling')
        break
    end
    waitbar(t/Tangle.simTime,f)
    
    % AIMD update every second
    if(floor(t)==t && t~=0)
        nOrphans = 0;
        for n = 1:Tangle.nNodes
            Results.alphas(n,t) = Tangle.Nodes(n).alpha;
            
            nodeOrphans = find(([Tangle.Sites.node]==n).*[Tangle.Sites.isTip].*([Tangle.Sites.age]>=Tangle.orphanAge));
            
            for o = nodeOrphans
                Tangle.Sites(o).node = 0; % remove association between this node and its orphaned site
            end
            
            nOrphans = nOrphans + length(nodeOrphans);
            if(t>1)
                Results.orphanRate(n,t) = length(nodeOrphans);
                Results.avgOrphanRate(n,:) = filter(Tangle.bAvgFilt,1,Results.orphanRate(n,:));
                Results.nOrphans(n,t) = Results.nOrphans(n,t-1) + length(nodeOrphans);
            else
                Results.orphanRate(n,t) = length(nodeOrphans);
                Results.avgOrphanRate(n,t) = length(nodeOrphans);
                Results.nOrphans(n,t) = length(nodeOrphans);
            end

%% AIMD Part
            if(Results.nOrphans(n,t)<Tangle.orphanRate) % additive increase
                Results.nOrphans(n,t) = 0; 
                Tangle.Nodes(n).alpha = Tangle.Nodes(n).alpha + Tangle.Nodes(n).alpha_AIMD;
            else % multiplicative decrease
                Tangle.Nodes(n).alpha = Tangle.Nodes(n).alpha*Tangle.Nodes(n).beta_AIMD;
            end
        end
        
%         if(nOrphans>0)
%             backOffNode = ceil(Tangle.nNodes*rand());
%         else
%             backOffNode = 0;
%         end
%         
%         for n = 1:Tangle.nNodes
%             if(n~=backOffNode) % additive increase
%                 Tangle.Nodes(n).alpha = Tangle.Nodes(n).alpha + Tangle.Nodes(n).alpha_AIMD;
%             else % multiplicative decrease
%                 Tangle.Nodes(n).alpha = Tangle.Nodes(n).alpha*Tangle.Nodes(n).beta_AIMD;
%             end
%         end
        
    end
    
    % add new arrivals for this time step by AIMD
    for node = 1:Tangle.nNodes
        if(t/Tangle.dt < Tangle.simTime)
            Tangle = newarrivals(Tangle, Tangle.lambda(ceil((t+Tangle.dt)/Tangle.dt))/Tangle.nNodes, 0, 0, node); % each node has equal proportion of computing power
        end
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
                n = Tangle.Sites(i).node;
                Tangle = selecttips(Tangle, i, Tangle.Nodes(n).alpha, Tangle.Nodes(n).beta, Tangle.Nodes(n).alpha, Tangle.Nodes(n).beta);
                
                Tangle.Sites(i).timePending = Tangle.Sites(i).timePending + Tangle.dt;
            end
            
        % else, this has been added to the tangle so increment its age
        else
            Tangle.Sites(i).age = Tangle.Sites(i).age + Tangle.dt;
            
        end        
    end
    
end
Results.FinalTangles(mcNum) = Tangle;
close(f);
delete(f);

