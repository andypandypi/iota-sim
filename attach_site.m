function Tangle = attach_site(Tangle, i)

Tangle.Sites(i).isAttached = true;
Tangle.Sites(i).isTip = true;

% this tips parents no longer tips
for c = Tangle.Sites(i).children
    Tangle.Sites(c).isTip = false;
    Tangle.Sites(c).timeAsTip = Tangle.Sites(c).age;
end

% Update cumulative weights and depths
Tangle = update_cumulative_weight(Tangle, i, i, Tangle.Sites(i).weight);
Tangle = update_depth(Tangle, i, 1);