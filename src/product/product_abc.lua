Locale = require("localization.locale")

Product = {}
Product.__index = Product

function Product:new(id, category, base_price)
    local obj = {
        id = id,
        category = category,
        base_price = base_price,
        localization_key = "product_" .. id
    }
    setmetatable(obj, Product)
    return obj
end

function Product:getName()
    return Locale:get(self.localization_key)
end

GH_MODULES["product.product_abc"] = Product
