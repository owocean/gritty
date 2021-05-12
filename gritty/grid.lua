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
    if self[y] and self[y][x] then return true else return false end
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

local function getRegionCells(startX, startY, grid)
    local cells = {}
    local mapFlags = {}
    for y=1, #grid do mapFlags[y] = {} for x=1, #grid[y] do mapFlags[y][x] = false end end
    local cellType = grid:get(startX, startY)
    local queue = {}
    queue[#queue+1] = {startY,startX}

    while #queue > 0 do
        local cell
        cell, queue[#queue] = queue[#queue], nil

        if grid:has(cell[2], cell[1]) and grid:get(cell[2], cell[1]) == cellType and mapFlags[cell[1]][cell[2]] == false then
            cells[#cells+1] = cell
            mapFlags[cell[1]][cell[2]] = true
            queue[#queue+1] = {cell[1],cell[2]+1}
            queue[#queue+1] = {cell[1],cell[2]-1}
            queue[#queue+1] = {cell[1]+1,cell[2]}
            queue[#queue+1] = {cell[1]-1,cell[2]}
        end
        
    end

    return cells
end

function Grid:getRegions(condition)
    local regions = {}
    local mapFlags = {}
    for y=1, #self do mapFlags[y] = {} for x=1, #self[y] do mapFlags[y][x] = false end end

    for y=1, #self do
        for x=1, #self do
            if mapFlags[y][x] == false and self:get(x,y) == condition then
                local region = getRegionCells(x,y,self)
                regions[#regions+1] = region

                for i=1, #region do
                    local cell = region[i]
                    mapFlags[cell[1]][cell[2]] = true
                end
            end
        end
    end

    return regions
end