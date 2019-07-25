function Tangle = doPoW(Tangle, i)
Tangle.Sites(i).poWDone = Tangle.Sites(i).poWDone + Tangle.dt*Tangle.Sites(i).computingPower;
% if this pending tip is finished PoW
if Tangle.Sites(i).poWDone >= Tangle.Sites(i).weight*Tangle.h
    % this tips parents no longer tips
    for c = Tangle.Sites(i).children
        Tangle.Sites(c).isTip = false;
        Tangle.Sites(c).timeAsTip = Tangle.Sites(c).age;
    end
    % add this tip to the tangle
    Tangle.Sites(i).isAttached = true;
    Tangle.Sites(i).isTip = true;
    % recursively update cumulative weights and depths
    Tangle = updatecumulativeweight(Tangle, i, i, Tangle.Sites(i).weight);
    Tangle = updatedepth(Tangle, i, 1);
end
end
