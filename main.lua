sliderM = require("sliderM")
textBoxM = require("textBoxM")
buttonM = require("buttonM")
presetM = require("presetM")

local renderable = nil
local drawImg = nil
amplitude = 1
frequency = 1
split = 0.5
hue = 0
pot = 1

Font = love.graphics.newFont("Pixellari.ttf", 32)


patternDim = 300

local rects = {}

function addPixelRect(x, y, width, height, colour, pX)
    local newRect = {
        x = x,
        y = y,
        width = width,
        height = height,
        colour = colour,
        pX = pX
    }

    table.insert(rects, newRect)

    return newRect
end

function love.load()
    


    Font:setFilter("nearest", "nearest")
    love.graphics.setDefaultFilter("nearest", "nearest")
    local bgC = 0.05
    love.graphics.setBackgroundColor(bgC,bgC,bgC)

    addPixelRect(335, 23, 422, 256, {r=0.2,g=0.2,b=0.2}, 2)

    sliderM:load()
    textBoxM:load()
    buttonM:load()
    presetM:load()

    render()
end

function pixelLoop(x, y)

    local noise = love.math.noise(x / amplitude, y / amplitude)

    local wave =
        ((math.sin(x * 0.12 + noise * frequency) * -split) + (math.cos(x * 0.12 + noise * frequency) * 1-(-split)))+
        ((math.sin(y * 0.12 + noise * frequency) * -split) + (math.cos(y * 0.12 + noise * frequency) * 1-(-split))) +
        ((math.sin((x+y) * 0.12 + noise * frequency) * -split) + (math.cos((x+y) * 0.12 + noise * frequency) * 1-(-split)))

    local value = (wave+3) / 6
    value = math.max(0, math.min(1, value))

    value = math.floor(value * pot) / pot

    local r, g, b = hsv(hue/100, 1, value)
    return r,g,b,1

end

function render()
    renderable = love.image.newImageData(patternDim, patternDim)
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
    textBoxM:update(dt)
    buttonM:update(dt)
    presetM:update(dt)
    render()
    
end


function love.draw(dt)
    love.graphics.setColor(1,1,1,1)
    if drawImg ~= nil then
        love.graphics.draw(drawImg, 20, 20, 0, 3/(patternDim / 100), 3/(patternDim / 100))
    end

    
    

    

    for _, i in pairs(rects) do
        love.graphics.setColor(i.colour.r,i.colour.g,i.colour.b, 1)
        love.graphics.rectangle("fill",i.x,i.y, i.width,i.height)


        love.graphics.rectangle("fill",i.x+(i.pX),i.y-(i.pX), i.width-(i.pX*2),(i.pX))
        love.graphics.rectangle("fill",i.x+(i.pX),i.y-(i.pX) + i.height + (i.pX), i.width-(i.pX*2),(i.pX))
        love.graphics.setColor(1,1,1,1)
    end

    

    sliderM:draw()
    textBoxM:draw()
    buttonM:draw()
    presetM:draw()
end

function love.mousepressed( x, y, button, istouch, presses )
    textBoxM:mousepressed( x, y, button, istouch, presses )
    buttonM:mousepressed( x, y, button, istouch, presses )
end

function mkdir(path)
    if package.config:sub(1, 1) == "\\" then
        return os.execute('mkdir "' .. path .. '"')
    else
        return os.execute('mkdir -p "' .. path .. '"')
    end
end



function encodeRender(pX, pY)
    local savePath = love.filesystem.getAppdataDirectory().. "/RegosPattern"
    mkdir(savePath)


    local imgRender = love.image.newImageData(pX, pY)
    for x = 0, imgRender:getWidth()-1 do
        for y = 0, imgRender:getHeight()-1 do
            r, g, b, a = pixelLoop(x, y)
            imgRender:setPixel(x, y, r, g, b, a)
        end
    end

    local encode = imgRender:encode("png")
    
    local file = io.open(savePath.. "/Render.png" , "w")
    love.system.openURL(savePath)

    file:write(encode:getString())

    file:close()
    print("successe")
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