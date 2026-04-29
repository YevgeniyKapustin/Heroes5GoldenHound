local Locale = require("localization.locale")

local Product = {}
Product.__index = Product

function Product:new(id, base_price)
    local obj = {
        id = id,
        base_price = base_price,
        localization_key = "product_" .. id
    }
    setmetatable(obj, Product)
    return obj
end

function Product:getName()
    return Locale:get(self.localization_key)
end

function Product:getId()
    return self.id
end

function Product:getBasePrice()
    return self.base_price
end

return Product
