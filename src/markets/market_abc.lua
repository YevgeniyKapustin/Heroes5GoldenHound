local Market = {}
Market.__index = Market

function Market:new()
    local obj = {
        supply = {},   -- { product_id = amount }
        demand = {},   -- { product_id = amount }
        prices = {}    -- { product_id = price }
    }
    setmetatable(obj, Market)
    return obj
end

function Market:addSupply(product_id, amount)
    self.supply[product_id] = (self.supply[product_id] or 0) + amount
end

function Market:buy(product_id, amount)
    local available = self.supply[product_id] or 0
    local bought = math.min(available, amount)

    self.supply[product_id] = available - bought
    return bought
end

function Market:getPrice(product)
    return self.prices[product.id] or product.base_price
end

function Market:updatePrices(products)
    for _, product in ipairs(products) do
        local id = product.id
        local supply = self.supply[id] or 0.0001
        local demand = self.demand[id] or 0

        local ratio = demand / supply
        self.prices[id] = product.base_price * ratio
    end
end

