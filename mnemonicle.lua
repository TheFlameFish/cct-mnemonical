local mnemonicle = {}

mnemonicle.dir = "/mnemonicle"

local globalFilePath = mnemonicle.dir .. "/global.json"
local localFilePath = mnemonicle.dir .. "/local.json"

function mnemonicle.init()
    globalFilePath = mnemonicle.dir .. "/global.json"
    localFilePath = mnemonicle.dir .. "/local.json"

    mnemonicle.loadGlobals()
    mnemonicle.loadLocals()
    mnemonicle.writeGlobals()
    mnemonicle.writeLocals()
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

function mnemonicle.test()
    print("test")
end

return mnemonicle