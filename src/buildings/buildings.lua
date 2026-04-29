local BuildingInstance = {}
BuildingInstance.__index = BuildingInstance

function BuildingInstance:new(buildingType)
    local obj = {
        type = buildingType,
        workers = {},
        efficiency = 1.0
    }
    setmetatable(obj, BuildingInstance)

    for _, prof in ipairs(buildingType.professions) do
        obj.workers[prof.id] = 0
    end

    return obj
end

function BuildingInstance:addWorkers(profession_id, count)
    local required = nil

    for _, prof in ipairs(self.type.professions) do
        if prof.id == profession_id then
            required = prof.required_workers
            break
        end
    end

    if not required then return end

    local current = self.workers[profession_id]
    local newCount = math.min(current + count, required)

    self.workers[profession_id] = newCount
end

function BuildingInstance:calculateEfficiency()
    local sum = 0
    local count = 0

    for _, prof in ipairs(self.type.professions) do
        local have = self.workers[prof.id]
        local need = prof.required_workers
        sum = sum + math.min(have / need, 1)
        count = count + 1
    end

    self.efficiency = sum / count
    return self.efficiency
end

function BuildingInstance:produce()
    local eff = self:calculateEfficiency()
    local output = {}

    for product_id, base_amount in pairs(self.type.produces) do
        output[product_id] = base_amount * eff
    end

    return output
end

function BuildingInstance:deliverToMarket(market)
    local produced = self:produce()

    for product_id, amount in pairs(produced) do
        market:addSupply(product_id, amount)
    end
end
