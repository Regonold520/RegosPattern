local sliderM = {}

local sliders = {}

local amplituideSlider = nil
local frequencySlider = nil
local ON = false

function sliderM:createSlider(id, length, min, max)
    local newSlider = {
        x = 0,
        y = 0,
        width = length,
        height = 10,
        min = min,
        max = max,
        currValue = 1,
        hovering = false,

        handle = {
            x = 0,
            y = 0,
            width = 10,
            height = 20
        }
    }

    sliders[id] = newSlider

    return newSlider
end


function sliderM:load()
    amplituideSlider = sliderM:createSlider("amplitude",200, 1, 100)


    amplituideSlider.x = 350
    amplituideSlider.y = 30

    frequencySlider = sliderM:createSlider("frequency",200, 0, 20)


    frequencySlider.x = 350
    frequencySlider.y = 70
end

local deltaTimer = 0
local hasADown = false
function sliderM:update(dt)
    deltaTimer = deltaTimer + dt

    amplitude = amplituideSlider.currValue
    frequency = frequencySlider.currValue
    

    for _,i in pairs(sliders) do
        i.handle.x = i.x + ((i.width / (i.max - i.min))*(i.currValue-i.min)) - i.handle.width/2
        i.handle.y = i.y-5

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
    end

end

function sliderM:draw()
    for _,i in pairs(sliders) do
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill",i.x,i.y, i.width,i.height)



        love.graphics.setColor(0.5,0.5,0.5,1)
        if i.hovering == true then
            love.graphics.setColor(1,0,0,1)
        end


        love.graphics.rectangle("fill",i.handle.x,i.handle.y, i.handle.width,i.handle.height, 0, i.height/2)
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