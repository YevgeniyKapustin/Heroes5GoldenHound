Logger = require("logger")

Turn = {}

function Turn.process(buildings, pops, market, productRegistry)
    Logger:info("Turn process phase: production")

    for _, building in ipairs(buildings) do
        building:deliverToMarket(market)
    end

    Logger:info("Turn process phase: income distribution")

    for _, building in ipairs(buildings) do
        local income = building:getIncome(market, productRegistry)
        local distribution = building:distributeIncome(income)

        for _, pop in ipairs(pops) do
            local share = distribution[pop.profession_id]
            if share then
                pop:receiveIncome(share)
            end
        end
    end

    Logger:info("Turn process phase: consumption")

    for _, pop in ipairs(pops) do
        pop:buyNeeds(market, productRegistry)
    end

    Logger:info("Turn process phase: pricing")
    market:updatePrices(productRegistry:list())
end

GH_MODULES["turn"] = Turn
