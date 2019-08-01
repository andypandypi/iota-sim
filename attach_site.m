function Tangle = attach_site(Tangle, i)
% ATTACH_SITE Marks a site as attached for finishing PoW.
%
%   Tangle = ATTACH_SITE(Tangle, i) attaches site i to the Tangle.
%   
%   Updates cumulative weight and depth for the whole Tangle.
%
%   See also UPDATE_CUMULATIVE_WEIGHT, UPDATE_DEPTH.

Tangle.Sites(i).isAttached = true;
Tangle.Sites(i).isTip = true;

% this tips parents no longer tips
for p = Tangle.Sites(i).parents
    Tangle.Sites(p).isTip = false;
    Tangle.Sites(p).timeAsTip = Tangle.Sites(p).age;
end

% Update cumulative weights and depths
Tangle = update_cumulative_weight(Tangle, i, i, Tangle.Sites(i).weight);
Tangle = update_depth(Tangle, i, 1);