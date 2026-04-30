Logger = require("logger")

BuildingInstance = {}
BuildingInstance.__index = BuildingInstance

function BuildingInstance:new(buildingType)
    local obj = {
        type = buildingType,
        workers = {},
        efficiency = 1.0
    }
    setmetatable(obj, BuildingInstance)

    for _, profession in ipairs(buildingType.professions) do
        obj.workers[profession.id] = 0
    end

    return obj
end

function BuildingInstance:addWorkers(profession_id, count)
    local required = nil

    for _, profession in ipairs(self.type.professions) do
        if profession.id == profession_id then
            required = profession.required_workers
            break
        end
    end

    if not required then
        return
    end

    local current = self.workers[profession_id] or 0
    if current + count < required then
        self.workers[profession_id] = current + count
    else
        self.workers[profession_id] = required
    end
    Logger:info("Workers assigned")
end

function BuildingInstance:calculateEfficiency()
    local sum = 0
    local count = 0

    for _, profession in ipairs(self.type.professions) do
        local have = self.workers[profession.id] or 0
        local need = profession.required_workers

        if need > 0 then
            if have / need < 1 then
                sum = sum + have / need
            else
                sum = sum + 1
            end
            count = count + 1
        end
    end

    if count == 0 then
        self.efficiency = 1
        return self.efficiency
    end

    self.efficiency = sum / count
    return self.efficiency
end

function BuildingInstance:produce()
    local output = {}
    local efficiency = self:calculateEfficiency()

    for product_id, base_amount in pairs(self.type.produces) do
        output[product_id] = base_amount * efficiency
    end

    return output
end

function BuildingInstance:deliverToMarket(market)
    local produced = self:produce()
    Logger:info("Building produced goods")

    for product_id, amount in pairs(produced) do
        market:addSupply(product_id, amount)
    end
end

function BuildingInstance:getIncome(market, productRegistry)
    local produced = self:produce()
    local income = 0

    for product_id, amount in pairs(produced) do
        local product = productRegistry:get(product_id)
        income = income + market:getPrice(product) * amount
    end

    Logger:info("Building income estimated")
    return income
end

function BuildingInstance:distributeIncome(totalIncome)
    local distribution = {}

    for _, profession in ipairs(self.type.professions) do
        distribution[profession.id] = totalIncome * profession.income_share
    end

    return distribution
end

GH_MODULES["buildings.buildings"] = BuildingInstance
