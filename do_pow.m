function Tangle = do_pow(Tangle, i)
Tangle.Sites(i).poWDone = Tangle.Sites(i).poWDone + Tangle.dt*Tangle.Sites(i).computingPower;
% if this pending tip is finished PoW
if Tangle.Sites(i).poWDone >= Tangle.Sites(i).weight*Tangle.Sites(i).h
    Tangle = attach_site(Tangle, i);
end
end
