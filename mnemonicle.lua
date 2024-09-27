local mnemonicle = {}

mnemonicle.dir = "/mnemonicle"

local globalFilePath = mnemonicle.dir .. "/global.json"
local localFilePath = mnemonicle.dir .. "/local.json"

mnemonicle.modes = {
    LOCAL = {localEnabled = true, globalEnabled = false}, -- Relies fully on local navigation, does not use global at all.
    GLOBAL = {localEnabled = false, globalEnabled = true}, -- Relies soley on global navigation, requires GPS at all times. Not reccomended.
    HYBRID = {localEnabled = true, globalEnabled = true} -- Uses GPS when available. Otherwise, uses local navigation. Reccomended.
}

mnemonicle.direction._local = {
    FORE = {},
    RIGHT = {},
    BACK = {},
    LEFT = {}
}
mnemonicle.direction._global = {
    NORTH = {}, -- z+
    EAST = {}, -- x+
    SOUTH = {}, -- z-
    WEST = {} -- x-
}
mnemonicle.localPositioning.data.facing = mnemonicle.direction._local.FORE
mnemonicle.globalPositioning.data.facing = mnemonicle.direction._global.NORTH
-- @param mode table: The mode of operation. Valid modes are modes.LOCAL, modes.GLOBAL, and modes.HYBRID.
function mnemonicle.init(mode)
    mode = mode or mnemonicle.modes.HYBRID

    -- Check if the provided mode matches one of the mode tables in mnemonicle.modes
    local validMode = false
    for _, availableMode in pairs(mnemonicle.modes) do
        if mode == availableMode then
            validMode = true
            break
        end
    end

    if not validMode then
        error("Invalid mode! Valid modes are modes.LOCAL, modes.GLOBAL, and modes.HYBRID.", 2)
    end

    mnemonicle.mode = mode

    globalFilePath = mnemonicle.dir .. "/global.json"
    localFilePath = mnemonicle.dir .. "/local.json"

    if mnemonicle.mode.localEnabled then
        mnemonicle.loadGlobals()
    end
    if mnemonicle.mode.globalEnabled then
        mnemonicle.loadLocals()
        mnemonicle.globalPositioning.updatePosition()
    end
end

mnemonicle.globalPositioning = {
    data = {
        position = {
            x = 0,
            y = 0,
            z = 0
        },
        localOrigin = {
            x = 0,
            y = 0,
            z = 0
        }
    }
}
mnemonicle.localPositioning = {
    data = {
        position = {
            x = 0,
            y = 0,
            z = 0
        }
    }
}


function mnemonicle.loadGlobals()
    if fs.exists(globalFilePath) then
        local file = fs.open(globalFilePath,"r")
        local contents = file.readAll()
        file.close()

        mnemonicle.globalPositioning.data = textutils.unserializeJSON(contents)
    end
    return mnemonicle.globalPositioning.data
end

function mnemonicle.loadLocals()
    if fs.exists(localFilePath) then
        local file = fs.open(localFilePath,"r")
        local contents = file.readAll()
        file.close()

        mnemonicle.localPositioning.data = textutils.unserializeJSON(contents)
    end
    return mnemonicle.localPositioning.data
end

function mnemonicle.writeGlobals()
    local file = fs.open(globalFilePath,"w")
    file.write(textutils.serialiseJSON(mnemonicle.globalPositioning.data))
    file.close()
end

function mnemonicle.writeLocals()
    local file = fs.open(localFilePath,"w")
    file.write(textutils.serialiseJSON(mnemonicle.localPositioning.data))
    file.close()
end

-- Calculations

-- Global Functions

-- @return table or nil: Global positioning of the turtle, including x, y, and z. Returns nil if gps call fails.
function mnemonicle.globalPositioning.updatePosition()
    local position = {
        x = nil,
        y =  nil,
        z = nil
    }

    position.x, position.y, position.z = gps.locate()

    if position.z then
        mnemonicle.globalPositioning.data.position = position
    end

    mnemonicle.writeGlobals()
    if position.z then 
        return position else
        return nil
    end
end

-- Moves the turtle around and uses the change in location from GPS to figure out the rotation of the turtle.
function mnemonicle.globalPositioning.calibrateRotation()
    
end

return mnemonicle