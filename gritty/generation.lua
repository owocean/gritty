require(gritty.path.."/grid")

function gritty.generate(x,y,val)
    local grid = Grid:create()
    for iy=1, y do
        grid[iy] = {}
        for ix=1, x do
            grid[iy][ix] = val or 0
        end
    end
    return grid
end

function gritty.generateConditioned(x,y,func)
    local grid = Grid:create()
    for iy=1, y do
        grid[iy] = {}
        for ix=1, x do
            grid[iy][ix] = func(ix,iy)
        end
    end
    return grid
end

function gritty.generateRandom(x,y,foo,bar)
    if not foo then foo = 1 end
    local grid = Grid:create()
    for iy=1, y do
        grid[iy] = {}
        for ix=1, x do
            grid[iy][ix] = ({foo,bar})[math.random(2)]
        end
    end
    return grid
end