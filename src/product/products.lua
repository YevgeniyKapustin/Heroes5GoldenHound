Product = require("product.product_abc")

ProductRegistry = {}
ProductRegistry.__index = ProductRegistry

function ProductRegistry:new(products)
    local obj = {
        list_data = products,
        by_id = {}
    }
    setmetatable(obj, ProductRegistry)

    for _, product in ipairs(products) do
        obj.by_id[product.id] = product
    end

    return obj
end

function ProductRegistry:get(id)
    return self.by_id[id]
end

function ProductRegistry:list()
    return self.list_data
end

GH_MODULES["product.products"] = ProductRegistry:new({
    Product:new("grain", "food", 10),
    Product:new("clothes", "clothing", 20),
    Product:new("furniture", "household", 50)
})
