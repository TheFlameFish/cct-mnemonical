local mnemonical = {}

mnemonical.dir = "/mnemonicle"

local globalFilePath = mnemonical.dir .. "/global.json"
local localFilePath = mnemonical.dir .. "/local.json"

function mnemonical.init()
    globalFilePath = mnemonical.dir .. "/global.json"
    localFilePath = mnemonical.dir .. "/local.json"

    mnemonical.loadGlobals()
    mnemonical.loadLocals()
    mnemonical.writeGlobals()
    mnemonical.writeLocals()
end

mnemonical.globalVars = {
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
mnemonical.localVars = {
    position = {
        x = 0,
        y = 0,
        z = 0
    }
}

function mnemonical.loadGlobals()
    if fs.exists(globalFilePath) then
        local file = fs.open(globalFilePath,"r")
        local contents = file.readAll()
        file.close()

        mnemonical.globalVars = textutils.unserializeJSON(contents)
    end
    return mnemonical.globalVars
end

function mnemonical.loadLocals()
    if fs.exists(localFilePath) then
        local file = fs.open(localFilePath,"r")
        local contents = file.readAll()
        file.close()

        mnemonical.localVars = textutils.unserializeJSON(contents)
    end
    return mnemonical.localVars
end

function mnemonical.writeGlobals()
    local file = fs.open(globalFilePath,"w")
    file.write(textutils.serialiseJSON(mnemonical.globalVars))
    file.close()
end

function mnemonical.writeLocals()
    local file = fs.open(localFilePath,"w")
    file.write(textutils.serialiseJSON(mnemonical.localVars))
    file.close()
end

function mnemonical.test()
    print("test")
end

return mnemonical