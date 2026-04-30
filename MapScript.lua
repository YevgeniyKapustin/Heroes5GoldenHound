GH_MODULES = {}
GH_LOADING_MODULES = {}
GH_MAP_ROOT = "Maps/SingleMissions/GoldenHound/"
GH_MODULE_FILES = {
    ["logger"] = GH_MAP_ROOT .. "src/logger.lua",
    ["game"] = GH_MAP_ROOT .. "src/game.lua",
    ["turn"] = GH_MAP_ROOT .. "src/turn.lua",
    ["buildings.buildings"] = GH_MAP_ROOT .. "src/buildings/buildings.lua",
    ["buildings.building_abc"] = GH_MAP_ROOT .. "src/buildings/building_abc.lua",
    ["buildings.types.substance_farm"] = GH_MAP_ROOT .. "src/buildings/types/substance_farm.lua",
    ["localization.locale"] = GH_MAP_ROOT .. "src/localization/locale.lua",
    ["localization.en"] = GH_MAP_ROOT .. "src/localization/en.lua",
    ["localization.ru"] = GH_MAP_ROOT .. "src/localization/ru.lua",
    ["markets.market_abc"] = GH_MAP_ROOT .. "src/markets/market_abc.lua",
    ["populations.pop_abc"] = GH_MAP_ROOT .. "src/populations/pop_abc.lua",
    ["populations.professions"] = GH_MAP_ROOT .. "src/populations/professions.lua",
    ["product.product_abc"] = GH_MAP_ROOT .. "src/product/product_abc.lua",
    ["product.products"] = GH_MAP_ROOT .. "src/product/products.lua"
}

function require(module_name)
    local cached = GH_MODULES[module_name]
    if cached ~= nil then
        return cached
    end

    if GH_LOADING_MODULES[module_name] then
        print("[ERROR] Circular module load detected: ", module_name)
        return nil
    end

    local module_file = GH_MODULE_FILES[module_name]
    if module_file == nil then
        print("[ERROR] Unknown module requested: ", module_name)
        return nil
    end

    GH_LOADING_MODULES[module_name] = 1
    doFile(module_file)
    GH_LOADING_MODULES[module_name] = nil

    local loaded = GH_MODULES[module_name]
    if loaded == nil then
        print("[ERROR] Module did not register itself: ", module_name)
    end

    return loaded
end

LOGGER = require("logger")
RUNTIME = require("game")

LOGGER:clear()
LOGGER:info("MapScript bootstrap started")

GoldenHound = RUNTIME:new()
GoldenHound:init()

LOGGER:info("MapScript bootstrap finished")

function ProcessGoldenHoundTurn()
    LOGGER:info("ProcessGoldenHoundTurn invoked")
    return GoldenHound:processTurn()
end

function GetGoldenHoundState()
    return GoldenHound:getState()
end

function GetGoldenHoundLogs()
    return LOGGER:getEntries()
end
