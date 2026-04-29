local landlord = Profession:new("landlord", "Landlord", 0.4, 10)
local farmer   = Profession:new("farmer",   "Farmer",   0.6, 90)

local SubsistenceFarmType = BuildingType:new(
    "subsistence_farm",
    "Subsistence Farm",
    { landlord, farmer },
    {
        grain = 100,
        clothes = 20,
        furniture = 5
    }
)
