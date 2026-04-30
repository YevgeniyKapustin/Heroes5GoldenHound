BuildingType = require("buildings.building_abc")
Profession = require("populations.professions")

landlord = Profession:new("landlord", "Landlord", 0.4, 10)
farmer = Profession:new("farmer", "Farmer", 0.6, 90)

GH_MODULES["buildings.types.substance_farm"] = BuildingType:new(
    "subsistence_farm",
    "Subsistence Farm",
    { landlord, farmer },
    {
        grain = 100,
        clothes = 20,
        furniture = 5
    }
)
