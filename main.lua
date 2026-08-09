sliderM = require("sliderM")

local renderable = nil
local drawImg = nil
amplitude = 1
frequency = 1

local patternDim = {x=100, y = 100}

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    sliderM:load()
    
    renderable = love.image.newImageData(patternDim.x, patternDim.y)
    
    render()
end

function pixelLoop(x, y)
    

    local noise = love.math.noise(x / amplitude, y / amplitude)

    local wave = 
        math.tan(x * 0.12 + noise * frequency) +
        math.cos(y * 0.12 + noise * frequency)

    if wave > 0 then
        return 1,1,1,1
    else
        return 0,0,0,1
    end

end

function render()
    for x = 0, renderable:getWidth()-1 do
        for y = 0, renderable:getHeight()-1 do
            r, g, b, a = pixelLoop(x, y)
            renderable:setPixel(x, y, r, g, b, a)
        end
    end
end

function love.update(dt)
    drawImg = love.graphics.newImage(renderable)

    sliderM:update(dt)
    render()
end

function love.draw(dt)
    love.graphics.setColor(1,1,1,1)
    if drawImg ~= nil then
        love.graphics.draw(drawImg, 20, 20, 0, 3, 3)
    end

    sliderM:draw()
end