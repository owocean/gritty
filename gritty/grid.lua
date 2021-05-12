Grid = {}

function Grid:create(o)
    return self
end

function Grid:get(x,y)
    return self[y][x]
end

function Grid:set(x,y,val)
    self[y][x] = val
end

function Grid:has(x,y)
    if y < 0 or y > #self then return false end
    if x < 0 or x > #self[1] then return false end
    return true
end

function Grid:neighbors(x,y,condition)
    local n = 0
    for iy=-1, 1 do
        for ix=-1, 1 do
            if (self[y+iy] and self[y+iy][x+ix]) and not (iy == 0 and ix == 0) then
                if (condition and self[y+iy][x+ix] == condition) or not condition then
                    n = n + 1
                end
            end
        end
    end
    return n
end

function Grid:borders(x,y,condition)
    local n = 0
    if self[y-1] and self[y-1][x] then if (condition and self[y-1][x] == condition) or not condition then n = n + 1 end end
    if self[y+1] and self[y+1][x] then if (condition and self[y+1][x] == condition) or not condition then n = n + 1 end end
    if self[y][x-1] then if (condition and self[y][x-1] == condition) or not condition then n = n + 1 end end
    if self[y][x+1] then if (condition and self[y][x+1] == condition) or not condition then n = n + 1 end end
    return n
end

function Grid:corners(x,y,condition)
    local n = 0
    if self[y-1] then
        if self[y-1][x-1] then if (condition and self[y-1][x-1] == condition) or not condition then n = n + 1 end end
        if self[y-1][x+1] then if (condition and self[y-1][x+1] == condition) or not condition then n = n + 1 end end
    end
    if self[y+1] then
        if self[y+1][x-1] then if (condition and self[y+1][x-1] == condition) or not condition then n = n + 1 end end
        if self[y+1][x+1] then if (condition and self[y+1][x+1] == condition) or not condition then n = n + 1 end end
    end
    return n
end

function Grid:bitmask(x,y,condition)
    local n = 0
    if self[y-1] and self[y-1][x] then
        if (condition and self[y-1][x] == condition) or not condition then n = n + 1 end
    end
    if self[y][x-1] then
        if (condition and self[y][x-1] == condition) or not condition then n = n + 2 end
    end
    if self[y][x+1] then
        if (condition and self[y][x+1] == condition) or not condition then n = n + 4 end
    end
    if self[y+1] and self[y+1][x] then
        if (condition and self[y+1][x] == condition) or not condition then n = n + 8 end
    end
    return n
end

function Grid:iterate(func)
    for y=1, #self do
        for x=1, #self do
            func(x,y,self[y][x])
        end
    end
end

function Grid:automata(func,condition)
    local newgrid = {}
    for i=1, #self do
        newgrid[i] = {}
    end
    for y=1, #self do
        for x=1, #self do
            newgrid[y][x] = func(self:neighbors(x,y,condition), self[y][x])
        end
    end
    for i=1, #self do
        self[i] = newgrid[i]
    end
end