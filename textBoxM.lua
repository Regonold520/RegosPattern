local textBoxM = {}

local textBoxes = {}


function textBoxM:addTextBox(x, y, width, labelTxt)
    local h = 35
    addPixelRect(x, y, width, h, {r=0,g=0,b=1}, 2)
    
    local newTextBox = {
        x = x,
        y = y,
        width = width,
        height = h,
        txt = {
            display = love.graphics.newText(Font, "aplk"),
            value = "aplk"
        },
        label = nil
    }

    newTextBox.label = {
        text = love.graphics.newText(Font, labelTxt)
    }

    table.insert(textBoxes, newTextBox)
end


function textBoxM:load()
    -- textBoxM:addTextBox(300, 300, 100, "sup")
end

function textBoxM:update(dt)
    x, y = love.mouse.getPosition( )
    
    for _,i in pairs(textBoxes) do
        if love.mouse.isDown(1) then
            if x > i.x and x <= i.x + i.width and
                y > i.y and y <= i.y + i.height then
                    
                i.selected = true     
            else
                i.selected = false
            end
        end
        
    end
end

function love.keypressed( key, scancode, isrepeat )
    for _,i in pairs(textBoxes) do
        if i.selected == true then
            if key == "backspace" then
                i.txt.value = i.txt.value:sub(1, #i.txt.value - 1)
                i.txt.display:set(i.txt.value)
            else
                i.txt.value = i.txt.value.. key
                i.txt.display:set(i.txt.value)
            end
        end
    end
end

function textBoxM:draw()
    for _,i in pairs(textBoxes) do
        love.graphics.setColor(1,1,1,1)

        love.graphics.draw(i.label.text,i.x + i.width + 20,i.y - (i.label.text:getHeight() / 2) + (i.height / 2) + 1, 0, 1 , 1)

        love.graphics.draw(i.txt.display,i.x + 3,i.y - (i.txt.display:getHeight() / 2) + (i.height / 2) + 1, 0, 1 , 1)

        love.graphics.setColor(0,1,0,1)

        love.graphics.rectangle("fill", i.x, i.y, 1, 1)

        love.graphics.setColor(1,1,1,1)
    end
end


return textBoxM