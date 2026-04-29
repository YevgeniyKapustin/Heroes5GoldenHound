local Pop = {}
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
end

function Pop:getDemand()
    local demand = {}

    for need, amount_per_person in pairs(self.needs) do
        demand[need] = amount_per_person * self.size
    end

    return demand
end

function Pop:consume(market)
    local demand = self:getDemand()

    for _, product_id in ipairs(self.priorities) do
        local need_type = market:getProductCategory(product_id)
        local required = demand[need_type]

        if required and required > 0 then
            local price = market:getPrice(product_id)
            local affordable = math.min(required, self.income / price)

            if affordable > 0 then
                market:buy(product_id, affordable)
                self.income = self.income - affordable * price
                demand[need_type] = demand[need_type] - affordable
            end
        end
    end
end

function Pop:buyNeeds(market, productRegistry)
    local demand = self:getDemand()

    for _, product_id in ipairs(self.priorities) do
        local product = productRegistry[product_id]
        local need_type = product.category
        local required = demand[need_type]

        if required and required > 0 then
            local price = market:getPrice(product)
            local affordable = math.min(required, self.income / price)

            if affordable > 0 then
                local bought = market:buy(product_id, affordable)
                self.income = self.income - bought * price
                demand[need_type] = demand[need_type] - bought
            end
        end
    end
end

