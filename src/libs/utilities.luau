local utiltiesModules = {}

--// check if a class has a tag!
function utiltiesModules:hasTag(tags, wanted)

    -- Does it contain this tag?
    for _, tag in ipairs(tags or {}) do
        if tag == wanted then
            return true
        end
    end

    -- No it doesn't!
    return false
end

return utiltiesModules