Logger = require("logger")

Pop = {}
Pop.__index = Pop

function Pop:new(id, profession_id, size, needs, priorities)
    local obj = {
        id = id,
        profession_id = profession_id,
        size = size,
        needs = needs,
        priorities = priorities,
        income = 0,
        workplace = nil
    }
    setmetatable(obj, Pop)
    return obj
end

function Pop:setWorkplace(building)
    self.workplace = building
end

function Pop:receiveIncome(amount)
    self.income = self.income + amount
    Logger:info("Income received")
end

function Pop:getDemand()
    local demand = {}

    for need, amount_per_person in pairs(self.needs) do
        demand[need] = amount_per_person * self.size
    end

    return demand
end

function Pop:buyNeeds(market, productRegistry)
    local demand = self:getDemand()
    Logger:info("Pop starts buying")

    for _, product_id in ipairs(self.priorities) do
        local product = productRegistry:get(product_id)
        if product then
            local need_type = product.category
            local required = demand[need_type]

            if required and required > 0 then
                local price = market:getPrice(product)
                local affordable = required

                if price > 0 then
                    if self.income / price < required then
                        affordable = self.income / price
                    end
                end

                if affordable > 0 then
                    local bought = market:buy(product_id, affordable)
                    self.income = self.income - bought * price
                    demand[need_type] = demand[need_type] - bought
                end
            end
        end
    end
end

GH_MODULES["populations.pop_abc"] = Pop
