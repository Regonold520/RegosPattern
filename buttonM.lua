local buttonM = {}

buttonM.buttons = {}

function buttonM:addButton(x, y, width, labelTxt, click)
    local h = 35
    
    
    local newButton = {
        x = x,
        y = y,
        rct = addPixelRect(x, y, width, h, {r=0.3,g=0.3,b=0.3}, 2),
        width = width,
        height = h,
        label = nil
    }

    newButton.onClick = click

    newButton.label = {
        text = love.graphics.newText(Font, labelTxt)
    }

    table.insert(buttonM.buttons, newButton)

    return newButton
end





function buttonM:load()
    buttonM:addButton(20, 430, 100, "Export",
    function ()
        encodeRender(textBoxM.pXBoxes.x.txt.value, textBoxM.pXBoxes.y.txt.value)
    end)
end

function buttonM:update(dt)
    for _,i in pairs(buttonM.buttons) do
        if x > i.x and x < i.x + i.width and y > i.y and y < i.y + i.height then
            if love.mouse.isDown(1) then
                i.rct.colour = {r=0.6,g=0.6,b=0.6}
            else
                i.rct.colour = {r=0.4,g=0.4,b=0.4}
            end
        else
            i.rct.colour = {r=0.3,g=0.3,b=0.3}
        end
    end
end

function buttonM:mousepressed( x, y, button, istouch, presses )
    for _,i in pairs(buttonM.buttons) do
        x, y = love.mouse.getPosition()

        if x > i.x and x < i.x + i.width and y > i.y and y < i.y + i.height then
            print(button)
            if button == 1 then
                i.onClick()
            end
        end
    end
end

function buttonM:draw()
    for _,i in pairs(buttonM.buttons) do
        love.graphics.setColor(1,1,1,1)

        love.graphics.draw(i.label.text,i.x + 3,i.y - (i.label.text:getHeight() / 2) + (i.height / 2) + 1, 0, 1 , 1)

        love.graphics.setColor(1,1,1,1)
    end
end

return buttonM