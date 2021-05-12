local gritty = require "gritty" -- import gritty

math.randomseed(os.time()) -- seed RNG

map = gritty.generateRandom(50, 50) -- create a 50x50 grid randomly composed of 1 or nil

function love.load()
    tilesetImage = love.graphics.newImage("tileset.png") -- load tileset image
    tilesetImage:setFilter("nearest", "linear")
    tilesetSprites = {}
    for i=0,15 do -- load all tiles as their own sprites
        tilesetSprites[#tilesetSprites+1] = love.graphics.newQuad(i * 9, 0, 9, 9, 144, 9)
    end
end

function love.draw()
    map:iterate(plot) -- built in function to iterate through the entire grid and execute callback
end

function plot(x,y,type) -- callback can accept x, y, and type
    if type == 1 then
        local bitmask = map:bitmask(x,y, 1) -- get bitmask value of current cell for bordering cells with value of 1
        love.graphics.draw(tilesetImage, tilesetSprites[bitmask+1], x*9, y*9) -- have to use `bitmask+1` because lua arrays start at 1
    else
        love.graphics.setColor(0x04/255, 0x84/255, 0xd1/255)
        love.graphics.rectangle("fill", x*9, y*9, 9, 9) -- otherwise draw water
        love.graphics.setColor(1,1,1)
    end
end

function love.keypressed(k)
    if k == "space" then
        map:automata(generateIslands, 1) -- when we press space, preform cellular automata using a custom function, and 1 as a condition to count neighbors
    end
end

function generateIslands(neighbors, cell)
    if neighbors > 4 then return 1 -- if cell has more than 4 neighbors, live
    elseif neighbors < 4 then return nil -- if cell has less than 4 neighbors, die
    else return cell end -- if cell has exactly 4 neighbors, do nothing
end