local Building = {}
Building.__index = Building

function Building:new(id, name, professions, produces)
    local obj = {
        id = id,
        name = name,
        professions = professions,
        produces = produces
    }
    setmetatable(obj, Building)
    return obj
end

return Building
