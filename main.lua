local renderable = nil
local drawImg = nil

local patternDim = {x=100, y = 100}

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    renderable = love.image.newImageData(patternDim.x, patternDim.y)
    
    for x = 0, renderable:getWidth()-1 do
        for y = 0, renderable:getHeight()-1 do
            r, g, b, a = pixelLoop(x, y)
            renderable:setPixel(x, y, r, g, b, a)
        end
    end
end

function pixelLoop(x, y)
    local amplitude = 10

    local noise = love.math.noise(x/amplitude, y/amplitude, (x+y)/amplitude)
    local noise2 = love.math.noise(y/amplitude, x/amplitude, (x+y)/amplitude)


    local on = 1
    if math.sin((noise*noise2)*10) > 0.5 then
        on = 0
    end

    return 1,0,1,on
end

function love.update(dt)
    drawImg = love.graphics.newImage(renderable)
end

function love.draw(dt)
    if drawImg ~= nil then
        love.graphics.draw(drawImg, 20, 20, 0, 3, 3)
    end
end