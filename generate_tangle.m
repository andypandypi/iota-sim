function Tangle = generate_tangle(Tangle)

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
    
    % Generate new sites
    Tangle = generate_sites(Tangle, Tangle.lambda, Tangle.mu, 2, 1);
    
    % Update tangle
    Tangle = update_tangle(Tangle);
    
    
    
end