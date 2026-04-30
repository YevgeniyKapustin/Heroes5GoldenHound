Logger = require("logger")

Market = {}
Market.__index = Market

function Market:new()
    local obj = {
        supply = {},
        demand = {},
        prices = {}
    }
    setmetatable(obj, Market)
    return obj
end

function Market:addSupply(product_id, amount)
    self.supply[product_id] = (self.supply[product_id] or 0) + amount
    Logger:info("Supply added")
end

function Market:addDemand(product_id, amount)
    self.demand[product_id] = (self.demand[product_id] or 0) + amount
end

function Market:buy(product_id, amount)
    local available = self.supply[product_id] or 0
    local bought = amount
    if available < amount then
        bought = available
    end

    self:addDemand(product_id, amount)
    self.supply[product_id] = available - bought
    Logger:info("Market buy")

    return bought
end

function Market:getPrice(product)
    return self.prices[product.id] or product.base_price
end

function Market:updatePrices(products)
    for _, product in ipairs(products) do
        local id = product.id
        local supply = self.supply[id] or 0
        local demand = self.demand[id] or 0
        local safeSupply = supply
        local safeDemand = demand

        if safeSupply < 1 then
            safeSupply = 1
        end

        if safeDemand < 1 then
            safeDemand = 1
        end

        self.prices[id] = product.base_price * (safeDemand / safeSupply)
        self.demand[id] = 0
    end
end

GH_MODULES["markets.market_abc"] = Market
