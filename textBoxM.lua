local textBoxM = {}

local textBoxes = {}


function textBoxM:addTextBox(x, y, width, labelTxt, limitedChar, maxSize)
    local h = 35
    
    
    local newTextBox = {
        x = x,
        y = y,
        limitedChar = limitedChar,
        maxSize = maxSize,
        rct = addPixelRect(x, y, width, h, {r=0.3,g=0.3,b=0.3}, 2),
        width = width,
        height = h,
        txt = {
            display = love.graphics.newText(Font, "100"),
            value = "100"
        },
        label = nil
    }

    newTextBox.label = {
        text = love.graphics.newText(Font, labelTxt)
    }

    table.insert(textBoxes, newTextBox)

    return newTextBox
end

textBoxM.pXBoxes = {
    x = nil,
    y = nil
}
function textBoxM:load()
    textBoxM.pXBoxes.x = textBoxM:addTextBox(20, 330, 100, "Image X", {"1","2","3","4","5","6","7","8","9","0"}, 4)
    textBoxM.pXBoxes.y = textBoxM:addTextBox(20, 380, 100, "Image Y", {"1","2","3","4","5","6","7","8","9","0"}, 4)
end

local blinkTimer = 0
local lastBlink = 0

function textBoxM:update(dt)
    blinkTimer = blinkTimer + (dt*1.5)

    lastBlink = math.floor(blinkTimer)
end

function love.keypressed( key, scancode, isrepeat )
    if key == "i" then
        encodeRender(tonumber(textBoxM.pXBoxes.x.txt.value), tonumber(textBoxM.pXBoxes.y.txt.value))
    end


    for _,i in pairs(textBoxes) do
        if i.selected == true then
            if key == "backspace" then
                i.txt.value = i.txt.value:sub(1, #i.txt.value - 1)
                i.txt.display:set(i.txt.value)
            else
                if #key == 1 then
                    local found = false
                    if i.limitedChar ~= {} then
                        for m,n in pairs(i.limitedChar) do
                            print("hi", n == key)
                            if n == key then
                               
                                found = true
                            end
                        end
                    else
                        found = true
                    end


                    if found == true then
                        if #i.txt.value + 1 <= i.maxSize then
                           i.txt.value = i.txt.value.. key
                            i.txt.display:set(i.txt.value) 
                        end
                    end
                end
            end
        end
    end
end

function love.mousepressed( x, y, button, istouch, presses )
    x, y = love.mouse.getPosition( )
    
    for _,i in pairs(textBoxes) do
        if x > i.x and x <= i.x + i.width and
            y > i.y and y <= i.y + i.height then
                
            i.selected = true     
            i.rct.colour = {r=0.5,g=0.5,b=0.5}
            lastBlink = 0
            blinkTimer = 0
        else
            i.selected = false
            i.rct.colour = {r=0.3,g=0.3,b=0.3}
        end
    end
end

function textBoxM:draw()
    for _,i in pairs(textBoxes) do
        love.graphics.setColor(1,1,1,1)

        love.graphics.draw(i.label.text,i.x + i.width + 10,i.y - (i.label.text:getHeight() / 2) + (i.height / 2) + 1, 0, 1 , 1)

        love.graphics.draw(i.txt.display,i.x + 3,i.y - (i.txt.display:getHeight() / 2) + (i.height / 2) + 1, 0, 1 , 1)

        love.graphics.setColor(0.8,0.8,0.8,1)
        if i.selected and lastBlink % 2 == 0 then
            love.graphics.rectangle("fill",i.x + i.txt.display:getWidth() + 4, i.y + 1, 7, i.height - 3)
        end
        love.graphics.setColor(1,1,1,1)
    end
end


return textBoxM