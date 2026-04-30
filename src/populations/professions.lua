Profession = {}
Profession.__index = Profession

function Profession:new(id, display_name, income_share, required_workers)
    local obj = {
        id = id,
        display_name = display_name,
        income_share = income_share,
        required_workers = required_workers
    }
    setmetatable(obj, Profession)
    return obj
end

GH_MODULES["populations.professions"] = Profession
