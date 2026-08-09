sliderM = require("sliderM")

local renderable = nil
local drawImg = nil
amplitude = 1
frequency = 1
split = 0.5
hue = 0

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
        ((math.sin(x * 0.12 + noise * frequency) * split) + (math.cos(x * 0.12 + noise * frequency) * 1-split))+
        ((math.sin(y * 0.12 + noise * frequency) * split) + (math.cos(y * 0.12 + noise * frequency) * 1-split)) + 
        ((math.sin((x+y) * 0.12 + noise * frequency) * split) + (math.cos((x+y) * 0.12 + noise * frequency) * 1-split))

    local value = (wave+3) / 6
    value = math.max(0, math.min(1, value))

    value = math.floor(value * 2) / 2

    local r, g, b = hsv(hue/100, 1, value)
    return r,g,b,1

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

function hsv(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end