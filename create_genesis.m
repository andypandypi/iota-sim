function Tangle = create_genesis(Tangle)

for k = 1:Tangle.nStartingTips
    Tangle.Sites(k) = newsite(1, 1, Tangle.nCW, 0);
    Tangle.Sites(k).isTip = 0;
    Tangle.Sites(k).isAttached = 1;
    Tangle.Sites(k).selectedParents = 1;
    Tangle.Sites(k).timePending = Tangle.dt;
end