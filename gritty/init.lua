gritty = {
    path = ...
}

require(gritty.path.."/generation")

local gritty = gritty
_G.gritty = nil
gritty.path = nil
return gritty