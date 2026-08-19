local presetM = {}

presetM.presetClickers = {}

tBxx = nil

function presetM:load()
    tBxx = textBoxM:addTextBox(705, 290, 50, "", {"1","2","3","4","5","6","7","8","9","0"}, 2)
    

    tBxx.txt.display:set("1")
    tBxx.txt.value = "1"
    

    buttonM:addButton(335, 290, 180, "Save Preset",
    function ()
        presetM:savePreset(tonumber(tBxx.txt.value), {
            amplitude = amplitude,
            frequency = frequency,
            split = split,
            hue = hue,
            scale = patternDim,
            pot = pot,
        })
    end)

    buttonM:addButton(520, 290, 180, "Load Preset",
    function ()
        presetM:applyPreset( presetM:loadPreset(tonumber(tBxx.txt.value)) )
    end)

    

    
end

function presetM:update(dt)
    print(tBxx.txt)
end

function presetM:draw()
end

local function serialize(value)
    if type(value) == "string" then
        return string.format("%q", value)
    elseif type(value) == "number" or type(value) == "boolean" then
        return tostring(value)
    elseif type(value) == "table" then
        local result = "{\n"

        for k, v in pairs(value) do
            result = result .. "    [" .. serialize(k) .. "] = " .. serialize(v) .. ",\n"
        end

        result = result .. "}"
        return result
    end
end

function presetM:applyPreset(preset)
    amplituideSlider.currValue = preset.amplitude
    frequencySlider.currValue = preset.frequency
    splitSlider.currValue = preset.split
    hueSlider.currValue = preset.hue
    scaleSlider.currValue = preset.scale
    potSlider.currValue = preset.pot

    print("Applied Preset")
end

function presetM:savePreset(idx, data)
    local savePath = love.filesystem.getAppdataDirectory().. "RegosPattern".. "/Preset"..tostring(idx).. ".lua"
    
    local file = io.open(savePath, "w")
    love.system.openURL(savePath)

    file:write("return ".. serialize(data))

    file:close()
end

function presetM:loadPreset(idx)
    local savePath = love.filesystem.getAppdataDirectory().. "RegosPattern".. "/Preset"..tostring(idx).. ".lua"

    local preset = nil
    if io.open(savePath, "r") ~= nil then
        preset = dofile(savePath )
    else
        print("erio")
    end
        

    return preset
end


return presetM