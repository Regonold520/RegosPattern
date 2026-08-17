local sliderM = {}

local sliders = {}

local amplituideSlider = nil
local frequencySlider = nil
local splitSlider = nil
local hueSlider = nil
local scaleSlider = nil
local potSlider = nil




local ON = false

function sliderM:createSlider(x, y, id, length, min, max, labelTxt)
    addPixelRect(x, y, length, 10, {r=1,g=1,b=1}, 2)
    
    local newSlider = {
        x = x,
        y = y,
        width = length,
        height = 10,
        min = min,
        max = max,
        currValue = min,
        hovering = false,

        handle = {
            x = 0,
            y = 0,
            width = 10,
            height = 25,
            rect = addPixelRect(0, 0, 10, 25, {r=0.5,g=0.5,b=0.5}, 2)
        },
        label = nil
    }

    

    newSlider.label = {
        text = love.graphics.newText(Font, labelTxt)
    }

    sliders[id] = newSlider

    return newSlider
end


function sliderM:load()
    
    
    amplituideSlider = sliderM:createSlider(350, 46,"amplitude",200, 1, 100, "Amplitude")

    frequencySlider = sliderM:createSlider(350, 86, "frequency",200, 0, 20, "Frequency")

    splitSlider = sliderM:createSlider(350, 126, "split",200, -5, 5, "Intensity")

    hueSlider = sliderM:createSlider(350, 166, "hue",200, 0, 100, "Hue")

    scaleSlider = sliderM:createSlider(350, 206, "scale",200, 10, 500, "Scale")

    potSlider = sliderM:createSlider(350, 246, "pot",200, 1, 10, "Posterization")
end

local deltaTimer = 0
local hasADown = false
function sliderM:update(dt)
    deltaTimer = deltaTimer + dt

    amplitude = amplituideSlider.currValue
    frequency = frequencySlider.currValue
    split = -splitSlider.currValue
    hue = hueSlider.currValue
    patternDim = scaleSlider.currValue
    pot = math.floor(potSlider.currValue)

    for _,i in pairs(sliders) do
        i.handle.x = i.x + ((i.width / (i.max - i.min))*(i.currValue-i.min)) - i.handle.width/2
        i.handle.y = i.y- 7.5

        x, y = love.mouse.getPosition( )

        if x > i.handle.x and x < i.handle.x + i.handle.width and
            y > i.handle.y and y < i.handle.y + i.handle.height then
            if hasADown == false then
                i.hovering = true
                hasADown = true
            end
            
        else
            if love.mouse.isDown(1) == false and i.hovering then
                i.hovering = false
                hasADown = false
            end   
        end

        i.handle.rect.x = i.handle.x
        i.handle.rect.y = i.handle.y
    end

end

function sliderM:draw()
    local px = 3
    for _,i in pairs(sliders) do
        love.graphics.setColor(1,1,1,1)
        -- love.graphics.rectangle("fill",i.x,i.y, i.width,i.height)


        -- love.graphics.rectangle("fill",i.x+(px),i.y-(px), i.width-(px*2),(px))
        -- love.graphics.rectangle("fill",i.x+(px),i.y-(px) + i.height + (px), i.width-(px*2),(px))



        i.handle.rect.colour = {r=0.5,g=0.5,b=0.5}
        if i.hovering == true then
            i.handle.rect.colour = {r=1,g=0,b=0}
        end


        love.graphics.draw(i.label.text,i.x + i.width + 10,i.y - (i.label.text:getHeight() / 2) + (i.height / 2), 0, 1 , 1)
    end
end

function love.mousemoved( x, y, dx, dy, istouch )
    if love.mouse.isDown(1) then
        for _,i in pairs(sliders) do
            if i.hovering == true then
                local newVal = i.currValue + dx / ((i.width / (i.max - i.min + 1)))

                if newVal <= i.max and newVal >= i.min then
                    x, y = love.mouse.getPosition()

                    
                    if newVal > i.max - 0.1 or newVal < i.min + 0.1 then
                        if x < i.x then
                            i.currValue = i.min
                        elseif x > i.x + i.width then
                            i.currValue = i.max
                        end
                    else
                        if x < i.x or x > i.x + i.width then
                            if x < i.x then
                                i.currValue = i.min
                            elseif x > i.x + i.width then
                                i.currValue = i.max
                            end
                        else
                            print(newVal)
                            i.currValue = newVal
                        end
                        
                    end

                    
                    
                end
            end
        end
    end
end


return sliderM