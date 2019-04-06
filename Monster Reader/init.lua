local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local lib_characters = require("solylib.characters")
local lib_unitxt = require("solylib.unitxt")
local lib_items = require("solylib.items.items")
local cfg = require("Monster Reader.configuration")
local cfgMonsters = require("Monster Reader.monsters")
local optionsLoaded, options = pcall(require, "Monster Reader.options")

local optionsFileName = "addons/Monster Reader/options.lua"
local firstPresent = true
local ConfigurationWindow

if optionsLoaded then
    -- If options loaded, make sure we have all those we need
    options.configurationEnableWindow = lib_helpers.NotNilOrDefault(options.configurationEnableWindow, true)
    options.enable                    = lib_helpers.NotNilOrDefault(options.enable, true)
    options.invertMonsterList         = lib_helpers.NotNilOrDefault(options.invertMonsterList, false)
    options.showCurrentRoomOnly       = lib_helpers.NotNilOrDefault(options.showCurrentRoomOnly, false)
    options.showMonsterStatus         = lib_helpers.NotNilOrDefault(options.showMonsterStatus, false)
    options.showMonsterID             = lib_helpers.NotNilOrDefault(options.showMonsterID, false)

    options.mhpEnableWindow      = lib_helpers.NotNilOrDefault(options.mhpEnableWindow, true)
    options.mhpChanged           = lib_helpers.NotNilOrDefault(options.mhpChanged, false)
    options.mhpAnchor            = lib_helpers.NotNilOrDefault(options.mhpAnchor, 1)
    options.mhpX                 = lib_helpers.NotNilOrDefault(options.mhpX, 50)
    options.mhpY                 = lib_helpers.NotNilOrDefault(options.mhpY, 50)
    options.mhpW                 = lib_helpers.NotNilOrDefault(options.mhpW, 450)
    options.mhpH                 = lib_helpers.NotNilOrDefault(options.mhpH, 350)
    options.mhpNoTitleBar        = lib_helpers.NotNilOrDefault(options.mhpNoTitleBar, "")
    options.mhpNoResize          = lib_helpers.NotNilOrDefault(options.mhpNoResize, "")
    options.mhpNoMove            = lib_helpers.NotNilOrDefault(options.mhpNoMove, "")
    options.mhpTransparentWindow = lib_helpers.NotNilOrDefault(options.mhpTransparentWindow, false)

    options.targetEnableWindow        = lib_helpers.NotNilOrDefault(options.targetEnableWindow, true)
    options.targetChanged             = lib_helpers.NotNilOrDefault(options.targetChanged, false)
    options.targetAnchor              = lib_helpers.NotNilOrDefault(options.targetAnchor, 3)
    options.targetX                   = lib_helpers.NotNilOrDefault(options.targetX, 150)
    options.targetY                   = lib_helpers.NotNilOrDefault(options.targetY, -45)
    options.targetW                   = lib_helpers.NotNilOrDefault(options.targetW, 120)
    options.targetH                   = lib_helpers.NotNilOrDefault(options.targetH, 85)
    options.targetNoTitleBar          = lib_helpers.NotNilOrDefault(options.targetNoTitleBar, "NoTitleBar")
    options.targetNoResize            = lib_helpers.NotNilOrDefault(options.targetNoResize, "NoResize")
    options.targetNoMove              = lib_helpers.NotNilOrDefault(options.targetNoMove, "NoMove")
    options.targetNoScrollbar         = lib_helpers.NotNilOrDefault(options.targetNoScrollbar, "NoScrollbar")
    options.targetTransparentWindow   = lib_helpers.NotNilOrDefault(options.targetTransparentWindow, false)
    options.targetShowMonsterName     = lib_helpers.NotNilOrDefault(options.targetShowMonsterName, false)
    options.targetShowMonsterStats    = lib_helpers.NotNilOrDefault(options.targetShowMonsterStats, false)
    options.targetShowAccuracyAssist  = lib_helpers.NotNilOrDefault(options.targetShowAccuracyAssist, false)
    options.targetAccuracyThreshold   = lib_helpers.NotNilOrDefault(options.targetAccuracyThreshold, 90)
    options.targetShowActivationRates = lib_helpers.NotNilOrDefault(options.targetShowActivationRates, 1)
    options.targetColors              = lib_helpers.NotNilOrDefault(options.targetColors, false)
    options.targetColorUtility        = lib_helpers.NotNilOrDefault(options.targetColorUtility, 1)
    options.targetColorsStatic        = lib_helpers.NotNilOrDefault(options.targetColorsStatic, false)
else
    options =
    {
        configurationEnableWindow = true,
        enable = true,
        invertMonsterList = false,
        showCurrentRoomOnly = false,
        showMonsterStatus = false,
        showMonsterID = false,

        mhpEnableWindow = true,
        mhpChanged = false,
        mhpAnchor = 1,
        mhpX = 50,
        mhpY = 50,
        mhpW = 450,
        mhpH = 350,
        mhpNoTitleBar = "",
        mhpNoResize = "",
        mhpNoMove = "",
        mhpTransparentWindow = false,

        targetEnableWindow = true,
        targetChanged = false,
        targetAnchor = 3,
        targetX = 150,
        targetY = -45,
        targetW = 120,
        targetH = 85,
        targetNoTitleBar = "NoTitleBar",
        targetNoResize = "NoResize",
        targetNoMove = "NoMove",
        targetNoScrollbar = "NoScrollbar",
        targetTransparentWindow = false,
        targetShowMonsterName = true,
        targetShowMonsterStats = true,
        targetShowAccuracyAssist = false,
        targetAccuracyThreshold = 90,
        targetShowActivationRates = 1,
        targetColors = false,
        targetColorUtility = 1,
		targetColorsStatic = false,
    }
end

local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write("return\n")
        io.write("{\n")
        io.write(string.format("    configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
        io.write(string.format("    enable = %s,\n", tostring(options.enable)))
        io.write(string.format("    invertMonsterList = %s,\n", tostring(options.invertMonsterList)))
        io.write(string.format("    showCurrentRoomOnly = %s,\n", tostring(options.showCurrentRoomOnly)))
        io.write(string.format("    showMonsterStatus = %s,\n", tostring(options.showMonsterStatus)))
        io.write(string.format("    showMonsterID = %s,\n", tostring(options.showMonsterID)))
        io.write("\n")
        io.write(string.format("    mhpEnableWindow = %s,\n", tostring(options.mhpEnableWindow)))
        io.write(string.format("    mhpChanged = %s,\n", tostring(options.mhpChanged)))
        io.write(string.format("    mhpAnchor = %i,\n", options.mhpAnchor))
        io.write(string.format("    mhpX = %i,\n", options.mhpX))
        io.write(string.format("    mhpY = %i,\n", options.mhpY))
        io.write(string.format("    mhpW = %i,\n", options.mhpW))
        io.write(string.format("    mhpH = %i,\n", options.mhpH))
        io.write(string.format("    mhpNoTitleBar = \"%s\",\n", options.mhpNoTitleBar))
        io.write(string.format("    mhpNoResize = \"%s\",\n", options.mhpNoResize))
        io.write(string.format("    mhpNoMove = \"%s\",\n", options.mhpNoMove))
        io.write(string.format("    mhpTransparentWindow = %s,\n", tostring(options.mhpTransparentWindow)))
        io.write("\n")
        io.write(string.format("    targetEnableWindow = %s,\n", tostring(options.targetEnableWindow)))
        io.write(string.format("    targetChanged = %s,\n", tostring(options.targetChanged)))
        io.write(string.format("    targetAnchor = %i,\n", options.targetAnchor))
        io.write(string.format("    targetX = %i,\n", options.targetX))
        io.write(string.format("    targetY = %i,\n", options.targetY))
        io.write(string.format("    targetW = %i,\n", options.targetW))
        io.write(string.format("    targetH = %i,\n", options.targetH))
        io.write(string.format("    targetNoTitleBar = \"%s\",\n", options.targetNoTitleBar))
        io.write(string.format("    targetNoResize = \"%s\",\n", options.targetNoResize))
        io.write(string.format("    targetNoMove = \"%s\",\n", options.targetNoMove))
        io.write(string.format("    targetNoScrollbar = \"%s\",\n", options.targetNoScrollbar))
        io.write(string.format("    targetTransparentWindow = %s,\n", tostring(options.targetTransparentWindow)))
        io.write(string.format("    targetShowMonsterName = %s,\n", tostring(options.targetShowMonsterName)))
        io.write(string.format("    targetShowMonsterStats = %s,\n", tostring(options.targetShowMonsterStats)))
        io.write(string.format("    targetShowAccuracyAssist = %s,\n", tostring(options.targetShowAccuracyAssist)))
        io.write(string.format("    targetAccuracyThreshold = %s,\n", tostring(options.targetAccuracyThreshold)))
        io.write(string.format("    targetShowActivationRates = %s,\n", tostring(options.targetShowActivationRates)))
		io.write(string.format("    targetColors = %s,\n", tostring(options.targetColors)))
		io.write(string.format("    targetColorUtility = %s,\n", tostring(options.targetColorUtility)))
		io.write(string.format("    targetColorsStatic = %s,\n", tostring(options.targetColorsStatic)))
        io.write("}\n")

        io.close(file)
    end
end

local _PlayerArray = 0x00A94254
local _PlayerIndex = 0x00A9C4F4
local _PlayerCount = 0x00AAE168
local _Difficulty = 0x00A9CD68
local _Ultimate

local _ID = 0x1C
local _Room = 0x28
local _Room2 = 0x2E
local _PosX = 0x38
local _PosY = 0x3C
local _PosZ = 0x40

local _targetPointerOffset = 0x18
local _targetOffset = 0x108C

local _EntityCount = 0x00AAE164
local _EntityArray = 0x00AAD720

local _MonsterUnitxtID = 0x378
local _MonsterHP = 0x334
local _MonsterHPMax = 0x2BC
local _MonsterEvp = 0x2D0
local _MonsterAtp = 0x2CC
local _MonsterDfp = 0x2D2
local _MonsterMst = 0x2BE
local _MonsterAta = 0x2D4
local _MonsterLck = 0x2D6
local _MonsterEfr = 0x2F6
local _MonsterEth = 0x2F8
local _MonsterEic = 0x2FA
local _MonsterEdk = 0x2FC
local _MonsterElt = 0x2FE

local _MonsterBpPtr = 0x2B4
local _MonsterBpAtp = 0x0
local _MonsterBpMst = 0x2
local _MonsterBpEvp = 0x4
local _MonsterBpHp  = 0x6
local _MonsterBpDfp = 0x8
local _MonsterBpAta = 0xA
local _MonsterBpLck = 0xC
local _MonsterBpEsp = 0xE

-- Special addresses for De Rol Le
local _BPDeRolLeData = 0x00A43CC8
local _MonsterDeRolLeHP = 0x6B4
local _MonsterDeRolLeHPMax = 0x6B0
local _MonsterDeRolLeSkullHP = 0x6B8
local _MonsterDeRolLeSkullHPMax = 0x20
local _MonsterDeRolLeShellHP = 0x39C
local _MonsterDeRolLeShellHPMax = 0x1C

-- Special addresses for Barba Ray
local _BPBarbaRayData = 0x00A43CC8
local _MonsterBarbaRayHP = 0x704
local _MonsterBarbaRayHPMax = 0x700
local _MonsterBarbaRaySkullHP = 0x708
local _MonsterBarbaRaySkullHPMax = 0x20
local _MonsterBarbaRayShellHP = 0x7AC
local _MonsterBarbaRayShellHPMax = 0x1C

-- Special address for Ephinea
local _ephineaMonsterArrayPointer = 0x00B5F800
local _ephineaMonsterHPScale = 0x00B5F804

-- Resistance color codes, mostly lifted from items_configuration.lua
-- fire ice thunder dark light
-- Originally used values lifted from items_configuration.lua but that didn't look as good as had hoped.
-- Opted for a more brightness scale within a color type.
-- Primary colors are fire - red, ice - blue, thunder - yellow, dark - violet, and light - green.
-- Also liked how 0xFF888888 looked for no good color so range is based 4 ranges from that color.
-- Keeping the Burning/Blizzard, Tempest, Hell, Gush shades as max brightness.
--
-- K, Started out with the idea of keeping the colors but I don't like how it's working.
-- So going with bright primary colors as much as possible.  RGB is easy.  Yellow, Violet are a tad tougher
-- I think I have too many colors to pick from too...

-- After considering for a while what I really want is to consider fire, ice, thunder, and lightning.
-- then have a simple gradient on dark.
-- So there are 3 color states of note and 1 empty color state.
-- The best element damage is brightest, second and 3rd best, then no color.

-- For Violet there are 3 color states as well, better than 25%, 25 to 60%, 90% and immune (no color)
local _ResistColors = {
    0xFFFF7734, -- Fire1 - Burning (very weak resist)
	0xFFE17B49, -- Fire2 - Flame
	0xFFC4805E, -- Fire3 - Fire
	0xFFA68473, -- Fire4 - Heat (very strong resist)
	0xFF31CBFF, -- Ice1 - Blizzard
	0xFF64D8FF, -- Ice2 - Freeze
	0xFF98E5FF, -- Ice3 - Frost
	0xFFCBF2FF, -- Ice4 - Ice
	0xFFEFEE00, -- Thunder1 - Tempest
	0xFFF3F240, -- Thunder2 - Storm
	0xFFF7F780, -- Thunder3 - Thunder
	0xFFFBFBBF, -- Thunder4 - Shock
	0xFFCB11FF, -- Dark1 - Hell
	0xFFD84DFF, -- Dark2 - Dark
	0xFFE588FF, -- Dark3 - Shadow
	0xFFF2C4FF, -- Dark4 - Dim
	0xFFFFFFFF, -- Light1 (first entry not lifted from elsewhere)
	0xFFDDDDDD, -- Light2 (considering using drain/gush colors)
	0xFFAAAAAA, -- Light3
	0xFF777777 -- Light4
}

--Haven't found a good pattern of colors so trying something different.
local _ColorSet = {
	0xFF0FAE00, -- Green (best choice)
	0xFFFFFF00, -- Yellow (OK choice)
	0xFFFF9400, -- Orange (bad choice)
	0xFFFF0000, -- Red (worst choice)
}

local function CopyMonster(monster)
    local copy = {}

    copy.address  = monster.address
    copy.index    = monster.index
    copy.id       = monster.id
    copy.room     = monster.room
    copy.posX     = monster.posX
    copy.posY     = monster.posY
    copy.posZ     = monster.posZ
    copy.unitxtID = monster.unitxtID
    copy.HP       = monster.HP
    copy.HPMax    = monster.HPMax
    copy.HP2      = monster.HP2
    copy.HP2Max   = monster.HP2Max
    copy.name     = monster.name
    copy.color    = monster.color
    copy.display  = monster.display

    return copy
end

local function GetMonsterDataDeRolLe(monster)
    local maxDataPtr = pso.read_u32(_BPDeRolLeData)
    local skullMaxHP = 0
    local shellMaxHP = 0
    local newName = monster.name
	local ephineaMonsters = pso.read_u32(_ephineaMonsterArrayPointer)
	local ephineaHPScale = 1.0
	
    if maxDataPtr ~= 0 then
        skullMaxHP = pso.read_u32(maxDataPtr + _MonsterDeRolLeSkullHPMax)
        shellMaxHP = pso.read_u32(maxDataPtr + _MonsterDeRolLeShellHPMax)
		if ephineaMonsters ~= 0 then
			ephineaHPScale = pso.read_f64(_ephineaMonsterHPScale)
			skullMaxHP = math.floor(skullMaxHP * ephineaHPScale)
			shellMaxHP = math.floor(shellMaxHP * ephineaHPScale)
		end
    end

    if monster.index == 0 then
        monster.HP = pso.read_u32(monster.address + _MonsterDeRolLeHP)
        monster.HPMax = pso.read_u32(monster.address + _MonsterDeRolLeHPMax)

        monster.HP2 = pso.read_u32(monster.address + _MonsterDeRolLeSkullHP)
        monster.HP2Max = skullMaxHP
    else
        monster.HP = pso.read_u32(monster.address + _MonsterDeRolLeShellHP)
        monster.HPMax = shellMaxHP
        monster.name = monster.name .. " Shell"
    end

    return monster
end

local function GetMonsterDataBarbaRay(monster)
    local maxDataPtr = pso.read_u32(_BPBarbaRayData)
    local skullMaxHP = 0
    local shellMaxHP = 0
    local newName = monster.name
	local ephineaMonsters = pso.read_u32(_ephineaMonsterArrayPointer)
	local ephineaHPScale = 1.0

    if maxDataPtr ~= 0 then
        skullMaxHP = pso.read_u32(maxDataPtr + _MonsterBarbaRaySkullHPMax)
        shellMaxHP = pso.read_u32(maxDataPtr + _MonsterBarbaRayShellHPMax)
		if ephineaMonsters ~= 0 then
			ephineaHPScale = pso.read_f64(_ephineaMonsterHPScale)
			skullMaxHP = math.floor(skullMaxHP * ephineaHPScale)
			shellMaxHP = math.floor(shellMaxHP * ephineaHPScale)
		end
    end

    if monster.index == 0 then
        monster.HP = pso.read_u32(monster.address + _MonsterBarbaRayHP)
        monster.HPMax = pso.read_u32(monster.address + _MonsterBarbaRayHPMax)

        monster.HP2 = pso.read_u32(monster.address + _MonsterBarbaRaySkullHP)
        monster.HP2Max = skullMaxHP
    else
        monster.HP = pso.read_u32(monster.address + _MonsterBarbaRayShellHP)
        monster.HPMax = shellMaxHP
        monster.name = monster.name .. " Shell"
    end

    return monster
end

local function GetMonsterData(monster)
    local ephineaMonsters = pso.read_u32(_ephineaMonsterArrayPointer)
	
    monster.id = pso.read_u16(monster.address + _ID)
    monster.unitxtID = pso.read_u32(monster.address + _MonsterUnitxtID)

	monster.HP = 0
	monster.HPMax = 0
	
	if ephineaMonsters ~= 0 then
		monster.HPMax = pso.read_u32(ephineaMonsters + (monster.id * 32))
		monster.HP = pso.read_u32(ephineaMonsters + (monster.id * 32) + 0x04)
	else
		monster.HP = pso.read_u16(monster.address + _MonsterHP)
		monster.HPMax = pso.read_u16(monster.address + _MonsterHPMax)
	end	
	
    local bpPointer = pso.read_u32(monster.address + _MonsterBpPtr)
    if bpPointer ~= 0 then
        monster.Atp = pso.read_u16(bpPointer + _MonsterBpAtp)
        monster.Mst = pso.read_u16(bpPointer + _MonsterBpMst)
        monster.Evp = pso.read_u16(bpPointer + _MonsterBpEvp)
        monster.Dfp = pso.read_u16(bpPointer + _MonsterBpDfp)
        monster.Ata = pso.read_u16(bpPointer + _MonsterBpAta)
        monster.Lck = pso.read_u16(bpPointer + _MonsterBpLck)
        monster.Esp = pso.read_u16(bpPointer + _MonsterBpEsp)
    else
        monster.Atp = pso.read_u16(monster.address + _MonsterAtp)
        monster.Dfp = pso.read_u16(monster.address + _MonsterDfp)
        monster.Evp = pso.read_u16(monster.address + _MonsterEvp)
        monster.Mst = pso.read_u16(monster.address + _MonsterMst)
        monster.Ata = pso.read_u16(monster.address + _MonsterAta)
        monster.Lck = pso.read_u16(monster.address + _MonsterLck)
        monster.Esp = 0
    end

    monster.Efr = pso.read_u16(monster.address + _MonsterEfr)
    monster.Eth = pso.read_u16(monster.address + _MonsterEth)
    monster.Eic = pso.read_u16(monster.address + _MonsterEic)
    monster.Edk = pso.read_u16(monster.address + _MonsterEdk)
    monster.Elt = pso.read_u16(monster.address + _MonsterElt)

    monster.room = pso.read_u16(monster.address + _Room)
    monster.posX = pso.read_f32(monster.address + _PosX)
    monster.posY = pso.read_f32(monster.address + _PosY)
    monster.posZ = pso.read_f32(monster.address + _PosZ)

    -- Other stuff
    monster.name = lib_unitxt.GetMonsterName(monster.unitxtID, _Ultimate)
    monster.color = 0xFFFFFFFF
    monster.display = true

    if monster.unitxtID == 45 then
        monster = GetMonsterDataDeRolLe(monster)
    end
    if monster.unitxtID == 73 then
        monster = GetMonsterDataBarbaRay(monster)
    end

    return monster
end

local function GetTargetMonster()
    local difficulty = pso.read_u32(_Difficulty)
    _Ultimate = difficulty == 3

    local pIndex = pso.read_u32(_PlayerIndex)
    local pAddr = pso.read_u32(_PlayerArray + 4 * pIndex)

    -- If we don't have address (maybe warping or something)
    if pAddr == 0 then
        return nil
    end

    local targetID = -1
    local targetPointerOffset = pso.read_u32(pAddr + _targetPointerOffset)
    if targetPointerOffset ~= 0 then
        targetID = pso.read_i16(targetPointerOffset + _targetOffset)
    end

    if targetID == -1 then
        return nil
    end

    local _targetPointerOffset = 0x18
    local _targetOffset = 0x108C

    local playerCount = pso.read_u32(_PlayerCount)
    local entityCount = pso.read_u32(_EntityCount)

    local i = 0
    while i < entityCount do
        local monster = {}

        monster.address = pso.read_u32(_EntityArray + 4 * (i + playerCount))
        -- If we got a pointer, then read from it
        if monster.address ~= 0 then
            monster.id = pso.read_i16(monster.address + _ID)

            if monster.id == targetID then
                monster = GetMonsterData(monster)
                return monster
            end
        end
        i = i + 1
    end

    return nil
end

local function GetMonsterList()
    local monsterList = {}

    local difficulty = pso.read_u32(_Difficulty)
    _Ultimate = difficulty == 3

    local pIndex = pso.read_u32(_PlayerIndex)
    local pAddr = pso.read_u32(_PlayerArray + 4 * pIndex)

    -- If we don't have address (maybe warping or something)
    -- return the empty list
    if pAddr == 0 then
        return monsterList
    end

    -- Get player position
    local playerRoom1 = pso.read_u16(pAddr + _Room)
    local playerRoom2 = pso.read_u16(pAddr + _Room2)
    local pPosX = pso.read_f32(pAddr + _PosX)
    local pPosZ = pso.read_f32(pAddr + _PosZ)

    local playerCount = pso.read_u32(_PlayerCount)
    local entityCount = pso.read_u32(_EntityCount)

    local i = 0
    while i < entityCount do
        local monster = {}

        monster.display = true
        monster.index = i
        monster.address = pso.read_u32(_EntityArray + 4 * (i + playerCount))

        -- If we got a pointer, then read from it
        if monster.address ~= 0 then
            monster = GetMonsterData(monster)

            if cfgMonsters.m[monster.unitxtID] ~= nil then
                monster.color = cfgMonsters.m[monster.unitxtID].color
                monster.display = cfgMonsters.m[monster.unitxtID].display
            end

            -- Calculate the distance between it and the player
            -- And hide the monster if its too far
            local xDist = math.abs(pPosX - monster.posX)
            local zDist = math.abs(pPosZ - monster.posZ)
            local tDist = math.sqrt(xDist ^ 2 + zDist ^ 2)

            if cfgMonsters.maxDistance ~= 0 and tDist > cfgMonsters.maxDistance then
                monster.display = false
            end

            -- Determine whether the player is in the same room as the monster
            if options.showCurrentRoomOnly and playerRoom1 ~= monster.room and playerRoom2 ~= monster.room then
                monster.display = false
            end

            -- Do not show monsters that have been killed
            if monster.HP <= 0 then
                monster.display = false
            end

            -- If we have De Rol Le, make a copy for the body HP
            if monster.unitxtID == 45 and monster.index == 0 then
                local head = CopyMonster(monster)
                table.insert(monsterList, head)

                monster.index = monster.index + 1
                monster.HP = monster.HP2
                monster.HPMax = monster.HP2Max
                monster.name = monster.name .. " Skull"
            elseif monster.unitxtID == 73 and monster.index == 0 then
                local head = CopyMonster(monster)
                table.insert(monsterList, head)

                monster.index = monster.index + 1
                monster.HP = monster.HP2
                monster.HPMax = monster.HP2Max
                monster.name = monster.name .. " Skull"
            end


            table.insert(monsterList, monster)
        end
        i = i + 1
    end

    return monsterList
end

local function PresentMonsters()
    local monsterList = GetMonsterList()
    local monsterListCount = table.getn(monsterList)

    local columnCount = 2

    -- Get how many columns we'll need
    if options.showMonsterID == true then
        columnCount = columnCount + 1
    end
    if options.showMonsterStatus == true then
        columnCount = columnCount + 1
    end
    imgui.Columns(columnCount)

    if options.showMonsterID == true or options.showMonsterStatus == true then
        local windowWidth = imgui.GetWindowSize()
        local charWidth = 0.7 * imgui.GetFontSize()

        local nameColumnWidth = #"XXXXXXXX" * charWidth + 10
        local idColumnWidth = #"XXXX" * charWidth + 10
        local statusColumnWidth = #"J30 Z30 F P" * charWidth + 10

        if options.showMonsterID == true and options.showMonsterStatus == true then
            imgui.SetColumnOffset(1, nameColumnWidth)
            imgui.SetColumnOffset(2, nameColumnWidth + idColumnWidth)
            imgui.SetColumnOffset(3, windowWidth - statusColumnWidth)
        elseif options.showMonsterID == true then
            imgui.SetColumnOffset(1, nameColumnWidth)
            imgui.SetColumnOffset(2, nameColumnWidth + idColumnWidth)
        elseif options.showMonsterStatus == true then
            imgui.SetColumnOffset(1, nameColumnWidth)
            imgui.SetColumnOffset(2, windowWidth - statusColumnWidth)
        else
            imgui.SetColumnOffset(1, nameColumnWidth)
        end
    end

    local startIndex = 1
    local endIndex = monsterListCount
    local step = 1

    if options.invertMonsterList then
        startIndex = monsterListCount
        endIndex = 1
        step = -1
    end

    for i=startIndex, endIndex, step do
        local monster = monsterList[i]
        if monster.display then
            local mHP = monster.HP
            local mHPMax = monster.HPMax

            lib_helpers.TextC(true, monster.color, monster.name)
            imgui.NextColumn()

            if options.showMonsterID == true then
                lib_helpers.Text(true, "%04X", monster.id)
                imgui.NextColumn()
            end

            lib_helpers.imguiProgressBar(true, mHP/mHPMax, -1.0, imgui.GetFontSize(), lib_helpers.HPToGreenRedGradient(mHP/mHPMax), nil, mHP)
            imgui.NextColumn()

            if options.showMonsterStatus then
                local atkTech = lib_characters.GetPlayerTechniqueStatus(monster.address, 0)
                local defTech = lib_characters.GetPlayerTechniqueStatus(monster.address, 1)

                if atkTech.type == 0 then
                    lib_helpers.TextC(true, 0, "    ")
                else
                    lib_helpers.TextC(true, 0xFFFF0000, atkTech.name .. atkTech.level .. string.rep(" ", 2 - #tostring(atkTech.level)) .. " ")
                end

                if defTech.type == 0 then
                    lib_helpers.TextC(false, 0, "    ")
                else
                    lib_helpers.TextC(false, 0xFF0000FF, defTech.name .. defTech.level .. string.rep(" ", 2 - #tostring(defTech.level)) .. " ")
                end

                local frozen = lib_characters.GetPlayerFrozenStatus(monster.address)
                local confused = lib_characters.GetPlayerConfusedStatus(monster.address)
                local paralyzed = lib_characters.GetPlayerParalyzedStatus(monster.address)

                if frozen then
                    lib_helpers.TextC(false, 0xFF00FFFF, "F ")
                elseif confused then
                    lib_helpers.TextC(false, 0xFFFF00FF, "C ")
                else
                    lib_helpers.TextC(false, 0, "  ")
                end
                if paralyzed then
                    lib_helpers.TextC(false, 0xFFFF4000, "P ")
                end

                imgui.NextColumn()
            end
        end
    end
end

local function PresentTargetMonster(monster)
    if monster ~= nil then
        local playerAddr = lib_characters.GetSelf()
        if playerAddr == 0 then
            return
        end

        local mHP = monster.HP
        local mHPMax = monster.HPMax

        local atkTech = lib_characters.GetPlayerTechniqueStatus(monster.address, 0)
        local defTech = lib_characters.GetPlayerTechniqueStatus(monster.address, 1)

        local frozen = lib_characters.GetPlayerFrozenStatus(monster.address)
        local confused = lib_characters.GetPlayerConfusedStatus(monster.address)
        local paralyzed = lib_characters.GetPlayerParalyzedStatus(monster.address)

        if options.targetShowMonsterName then
            lib_helpers.Text(true, monster.name)
        end
        if options.showMonsterID == true then
            lib_helpers.Text(false, " - ID: %04X", monster.id)
        end

        -- Show target enemies stats if feature enabled
        if options.targetShowMonsterStats then
            lib_helpers.Text(true, "[ATP: %i, DFP: %i, MST: %i, ATA: %i, EVP: %i, LCK: %i]",
                                   monster.Atp, monster.Dfp, monster.Mst, monster.Ata, monster.Evp, monster.Lck)
			--Check for colorized?
			if not options.targetColors then
				lib_helpers.Text(true, "[EFR: %i, EIC: %i, ETH: %i, EDK: %i, ELT: %i, ESP: %i]",
									   monster.Efr, monster.Eic, monster.Eth, monster.Edk, monster.Elt, monster.Esp)
			else
				--Text to be displayed (color coded by element)
				local restext = {}
				restext[1] = "EFR: "
				restext[2] = "EIC: "
				restext[3] = "ETH: "
				restext[4] = "EDK: "
				restext[5] = "ELT: "
				
				--Data to be (usability color) displayed with text.
				local resdata = {}
				resdata[1] = monster.Efr
				resdata[2] = monster.Eic
				resdata[3] = monster.Eth
				resdata[4] = monster.Edk
				resdata[5] = monster.Elt
				
				--Sorted array of 4 main elements (exclude Edk due to it's different behavior)
				local ressort = {}
				local i = 1
				for k,v in ipairs(resdata) do
					if(k ~= 4) then
						ressort[i] = v
						i = i + 1
					end
				end
				table.sort(ressort)
				
				--reverse lookup to convert monster resistance into usable color index.
				local resindex = {}
				i = 1
				for k,v in ipairs(ressort) do
					if(not resindex[v]) then
						resindex[v] = k
						i = i + 1
					end
				end
				
				--Setup the colors to be used when printing.
				restextpc = {}
				restextuc = {}
				for k,v in ipairs(restext) do
					if options.targetColorsStatic then
						restextpc[k] = _ResistColors[((k-1)*4)+1]
					else
						--special case EDK...
						if(k == 4) then
							restextpc[k] = _ResistColors[((k-1)*4)+(math.floor(monster.Edk/25)+1)]
						else
							restextpc[k] = _ResistColors[((k-1)*4)+resindex[resdata[k]]]
						end
					end
					
					if(options.targetColorUtility == 2) then
						--EDK special case...
						if(k == 4) then
							restextuc[k] = _ResistColors[((k-1)*4)+(math.floor(monster.Edk/25)+1)]
						else
							restextuc[k] = _ResistColors[((k-1)*4)+resindex[resdata[k]]]
						end
					else
						--Ah... EDK again...
						if(k == 4) then
							restextuc[k] = _ColorSet[math.floor((monster.Edk/25)+1)]
						else
							restextuc[k] = _ColorSet[resindex[resdata[k]]]
						end
					end
				end
				
				--Do the printing.
				lib_helpers.Text(true, "[")
				for k,v in ipairs(restext) do
					if(resdata[k] == 100) then
						--Print white text if the resdata indicates complete immunity.
						lib_helpers.Text(false, v)
						lib_helpers.Text(false, "%i", resdata[k])
					else
						--Print the colored text.
						lib_helpers.TextC(false, restextpc[k], v)
						lib_helpers.TextC(false, restextuc[k], "%i", resdata[k])
					end
					--Print the spacers between each text set.
					lib_helpers.Text(false, ", ")
				end
				lib_helpers.Text(false, "ESP: %i]", monster.Esp)
			end
		end

        -- Draw enemy HP bar
        lib_helpers.imguiProgressBar(true, mHP/mHPMax, -1.0, imgui.GetFontSize(), lib_helpers.HPToGreenRedGradient(mHP/mHPMax), nil, mHP)

        -- Show J/Z status and Frozen, Confuse, or Paralyzed status
        if options.showMonsterStatus then
            if atkTech.type == 0 then
                lib_helpers.TextC(true, 0, "    ")
            else
                lib_helpers.TextC(true, 0xFFFF0000, atkTech.name .. atkTech.level .. string.rep(" ", 2 - #tostring(atkTech.level)) .. " ")
            end

            if defTech.type == 0 then
                lib_helpers.TextC(false, 0, "    ")
            else
                lib_helpers.TextC(false, 0xFF0000FF, defTech.name .. defTech.level .. string.rep(" ", 2 - #tostring(defTech.level)) .. " ")
            end

            if frozen then
                lib_helpers.TextC(false, 0xFF00FFFF, "F ")
            elseif confused then
                lib_helpers.TextC(false, 0xFFFF00FF, "C ")
            else
                lib_helpers.TextC(false, 0, "  ")
            end
            if paralyzed then
                lib_helpers.TextC(false, 0xFFFF4000, "P ")
            end

            imgui.NextColumn()
        end

        -- Determine if we have v501/v502 equip for it's bonuses
        local inventory = lib_items.GetInventory(lib_items.Me)
        local itemCount = table.getn(inventory.items)
        local v50xHellBoost = 1.0
        local v50xStatusBoost = 1.0
        for i=1,itemCount,1 do
            item = inventory.items[i]
            if item.equipped and item.data[1] == 0x01 and item.data[2] == 0x03 then
                -- V501
                if item.data[3] == 0x4A then
                    v50xHellBoost = 1.5
                    v50xStatusBoost = 1.5
                -- V502
                elseif item.data[3] == 0x4B then
                    v50xHellBoost = 2.0
                    v50xStatusBoost = 1.5
                    break
                end
            end
        end

        -- Show accuracy assistance if feature is enabled
        if options.targetShowAccuracyAssist then
            -- Determine if player gets a bonus due to enemy status
            local badStatusReduc = 1.0
            if frozen then
                badStatusReduc = badStatusReduc - 0.3
            end
            if paralyzed then
                badStatusReduc = badStatusReduc - 0.15
            end

            -- Calculate all 9 types of attack combinations
            local myAta = lib_characters.GetPlayerATA(playerAddr)
            local normAtk1_Acc = (myAta * 1.0 * 1.0 ) - ((monster.Evp * badStatusReduc) * 0.2)
            local hardAtk1_Acc = (myAta * 0.7 * 1.0 ) - ((monster.Evp * badStatusReduc) * 0.2)
            local specAtk1_Acc = (myAta * 0.5 * 1.0 ) - ((monster.Evp * badStatusReduc) * 0.2)
            local normAtk2_Acc = (myAta * 1.0 * 1.3 ) - ((monster.Evp * badStatusReduc) * 0.2)
            local hardAtk2_Acc = (myAta * 0.7 * 1.3 ) - ((monster.Evp * badStatusReduc) * 0.2)
            local specAtk2_Acc = (myAta * 0.5 * 1.3 ) - ((monster.Evp * badStatusReduc) * 0.2)
            local normAtk3_Acc = (myAta * 1.0 * 1.69) - ((monster.Evp * badStatusReduc) * 0.2)
            local hardAtk3_Acc = (myAta * 0.7 * 1.69) - ((monster.Evp * badStatusReduc) * 0.2)
            local specAtk3_Acc = (myAta * 0.5 * 1.69) - ((monster.Evp * badStatusReduc) * 0.2)

            -- Display best first attack
            lib_helpers.Text(true, "Ata: %i, Recommended Attack:", myAta)
            lib_helpers.Text(true, "[")
            if specAtk1_Acc >= options.targetAccuracyThreshold then
                lib_helpers.TextC(false, 0xFFFF0000, "Spec1: %i%%%% ", specAtk1_Acc)
            elseif hardAtk1_Acc >= options.targetAccuracyThreshold then
                lib_helpers.TextC(false, 0xFFFFAA00, "Hard1: %i%%%% ", hardAtk1_Acc)
            else
                lib_helpers.TextC(false, 0xFF00FF00, "Norm1: %i%%%% ", normAtk1_Acc)
            end

            -- Display best second attack
            lib_helpers.Text(false, "> ")
            if specAtk2_Acc >= options.targetAccuracyThreshold then
                lib_helpers.TextC(false, 0xFFFF0000, "Spec2: %i%%%% ", specAtk2_Acc)
            elseif hardAtk2_Acc >= options.targetAccuracyThreshold then
                lib_helpers.TextC(false, 0xFFFFAA00, "Hard2: %i%%%% ", hardAtk2_Acc)
            else
                lib_helpers.TextC(false, 0xFF00FF00, "Norm2: %i%%%% ", normAtk2_Acc)
            end

            -- Display best third attack
            lib_helpers.Text(false, "> ")
            if specAtk3_Acc >= options.targetAccuracyThreshold then
                lib_helpers.TextC(false, 0xFFFF0000, "Spec1: %i%%%%", specAtk3_Acc)
            elseif hardAtk3_Acc >= options.targetAccuracyThreshold then
                lib_helpers.TextC(false, 0xFFFFAA00, "Hard1: %i%%%%", hardAtk3_Acc)
            else
                lib_helpers.TextC(false, 0xFF00FF00, "Norm1: %i%%%%", normAtk3_Acc)
            end
            lib_helpers.Text(false, "]")
        end

        -- Show special activation rate if feature is enabled
        if options.targetShowActivationRates > 1 then
            -- Determine if the Android Boost Applies
            local androidBoost = 0
            if lib_characters.GetPlayerIsCast(playerAddr) == true then
                androidBoost = 30
            end

            -- Calculate Rates of success of differing attack types
            local hellRate = (93 - monster.Edk)*(v50xHellBoost)
            lib_helpers.Text(true, "Activation Rates:")
            if options.targetShowActivationRates == 2 then
                lib_helpers.Text(true, "Hell: %i%%%%", hellRate)
            else
                local arrestRate = (80 + androidBoost - monster.Esp)*(v50xStatusBoost)
                lib_helpers.Text(true, "Hell: %i%%%%, Arrest/Blizzard: %i%%%%", hellRate, arrestRate)
                if options.targetShowActivationRates > 3 then
                    local seizeRate = (64 + androidBoost - monster.Esp)*(v50xStatusBoost)
                    local chaosRate = (76 + androidBoost - monster.Esp)*(v50xStatusBoost)
                    local havocRate = (60 + androidBoost - monster.Esp)*(v50xStatusBoost)
                    lib_helpers.Text(true, "Seize: %i%%%%, Chaos: %i%%%%, Havoc: %i%%%%", seizeRate, chaosRate, havocRate)
                end
            end
        end
    end
end

-- Need to use this so I can hide the window when nothing is targetted
local targetCache = nil
local targetWindowTimeOut = 0
local function PresentTargetMonsterWindow()
    local monster = GetTargetMonster()

    if monster == nil then
        if targetWindowTimeOut > 0 then
            targetWindowTimeOut = targetWindowTimeOut - 1
        end

        monster = targetCache
        if targetWindowTimeOut <= 0 then
            return
        end
    else
        targetWindowTimeOut = 90
        targetCache = monster
    end

    if options.targetEnableWindow and monster.unitxtID ~= 0 then
        if firstPresent or options.targetChanged then
          options.targetChanged = false
          local ps = lib_helpers.GetPosBySizeAndAnchor(options.targetX, options.targetY, options.targetW, options.targetH, options.targetAnchor)
          imgui.SetNextWindowPos(ps[1], ps[2], "Always");
          imgui.SetNextWindowSize(options.targetW, options.targetH, "Always");
        end

        if options.targetTransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin("Monster Reader - Target", nil, { options.targetNoTitleBar, options.targetNoResize, options.targetNoMove, options.targetNoScrollbar }) then
            PresentTargetMonster(monster)
        end
        imgui.End()

        if options.targetTransparentWindow == true then
          imgui.PopStyleColor()
        end
    end
end

local function present()
    -- If the addon has never been used, open the config window
    -- and disable the config window setting
    if options.configurationEnableWindow then
        ConfigurationWindow.open = true
        options.configurationEnableWindow = false
    end

    ConfigurationWindow.Update()
    if ConfigurationWindow.changed then
        ConfigurationWindow.changed = false
        SaveOptions(options)
    end

    -- Global enable here to let the configuration window work
    if options.enable == false then
        return
    end

    if options.mhpEnableWindow then
        if firstPresent or options.mhpChanged then
            options.mhpChanged = false
            local ps = lib_helpers.GetPosBySizeAndAnchor(options.mhpX, options.mhpY, options.mhpW, options.mhpH, options.mhpAnchor)
            imgui.SetNextWindowPos(ps[1], ps[2], "Always");
            imgui.SetNextWindowSize(options.mhpW, options.mhpH, "Always");
        end

        if options.mhpTransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin("Monster Reader - HP", nil, { options.mhpNoTitleBar, options.mhpNoResize, options.mhpNoMove }) then
            PresentMonsters()
        end
        imgui.End()

        if options.mhpTransparentWindow == true then
            imgui.PopStyleColor()
        end
    end

    PresentTargetMonsterWindow()

    if firstPresent then
        firstPresent = false
    end
end

local function init()
    ConfigurationWindow = cfg.ConfigurationWindow(options)

    local function mainMenuButtonHandler()
        ConfigurationWindow.open = not ConfigurationWindow.open
    end

    core_mainmenu.add_button("Monster Reader", mainMenuButtonHandler)

    return
    {
        name = "Monster Reader",
        version = "1.0.5",
        author = "Solybum",
        description = "Information about monsters",
        present = present,
    }
end

return
{
    __addon =
    {
        init = init
    }
}
