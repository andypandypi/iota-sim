function tip = uniform_random_tip_selection(Tangle)

tipIndices = find([Tangle.Sites(:).isTip]);
nTips = length(tipIndices);
iTip = ceil(nTips*rand());
tip = tipIndices(iTip);