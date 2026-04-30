Locale = {
    current = "en",
    languages = {}
}

function Locale:load(lang)
    self.languages[lang] = require("localization." .. lang)
end

function Locale:set(lang)
    self.current = lang
end

function Locale:get(id)
    local lang = self.languages[self.current]
    if lang and lang[id] then
        return lang[id]
    end
    return id
end

GH_MODULES["localization.locale"] = Locale
