local Product = require("product.product_abc")

local products = {
    Product:new("grain", 10),
    Product:new("clothes", 20),
    Product:new("furniture", 50)
}

function GetProduct(id)
    for _, product in ipairs(products) do
        if product.id == id then
            return product
        end
    end
    return nil
end

return products
