function ProcessTurn(buildings, pops, market, products)
    -- 1. Здания производят товары
    for _, building in ipairs(buildings) do
        building:deliverToMarket(market)
    end

    -- 2. POP’ы получают доход
    for _, building in ipairs(buildings) do
        local income = building:getIncome()
        local distribution = building:distributeIncome(income)

        for _, pop in ipairs(pops) do
            if distribution[pop.profession_id] then
                pop:receiveIncome(distribution[pop.profession_id])
            end
        end
    end

    -- 3. POP’ы покупают товары
    for _, pop in ipairs(pops) do
        pop:buyNeeds(market, products)
    end

    -- 4. Обновляем цены
    market:updatePrices(products)
end
