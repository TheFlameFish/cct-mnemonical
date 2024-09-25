local mnemonicle = {}

mnemonicle.dir = "/mnemonicle"

local globalFilePath = mnemonicle.dir .. "/global.json"
local localFilePath = mnemonicle.dir .. "/local.json"

mnemonicle.modes = {
    LOCAL = {localEnabled = true, globalEnabled = false}, -- Relies fully on local navigation, does not use global at all.
    GLOBAL = {localEnabled = false, globalEnabled = true}, -- Relies soley on global navigation, requires GPS at all times. Not reccomended.
    HYBRID = {localEnabled = true, globalEnabled = true} -- Uses GPS when available. Otherwise, uses local navigation. Reccomended.
}

function mnemonicle.init(mode)
    mnemonicle.mode = mode or mnemonicle.modes.HYBRID
    if not mnemonicle.modes[mnemonicle.mode] then
        error("Invalid mode! Valid modes are mnemonicle.LOCAL, mnemonicle.GLOBAL, and mnemonicle.HYBRID.",2)
    end
    globalFilePath = mnemonicle.dir .. "/global.json"
    localFilePath = mnemonicle.dir .. "/local.json"

    if mnemonicle.mode.localEnabled then
        mnemonicle.loadGlobals()
    end
    if mnemonicle.mode.globalEnabled then
        mnemonicle.loadLocals()
    end
end

mnemonicle.globalVars = {
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
mnemonicle.localVars = {
    position = {
        x = 0,
        y = 0,
        z = 0
    }
}

function mnemonicle.loadGlobals()
    if fs.exists(globalFilePath) then
        local file = fs.open(globalFilePath,"r")
        local contents = file.readAll()
        file.close()

        mnemonicle.globalVars = textutils.unserializeJSON(contents)
    end
    return mnemonicle.globalVars
end

function mnemonicle.loadLocals()
    if fs.exists(localFilePath) then
        local file = fs.open(localFilePath,"r")
        local contents = file.readAll()
        file.close()

        mnemonicle.localVars = textutils.unserializeJSON(contents)
    end
    return mnemonicle.localVars
end

function mnemonicle.writeGlobals()
    local file = fs.open(globalFilePath,"w")
    file.write(textutils.serialiseJSON(mnemonicle.globalVars))
    file.close()
end

function mnemonicle.writeLocals()
    local file = fs.open(localFilePath,"w")
    file.write(textutils.serialiseJSON(mnemonicle.localVars))
    file.close()
end

-- Calculations


-- Movement Functions


return mnemonicle