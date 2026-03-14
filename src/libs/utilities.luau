local utiltiesModules = {}

--// Fuzzy match algorithm (I dont really understand the inner workings tbh)
function utiltiesModules:fuzzySearch(query : string, target : string): (boolean, number)
    -- Convert our query & target to lowercase
    query = query:lower()
    target = target:lower()

    -- If query is nothing, then return default.
    if query == "" then 
        return true, 0
    end

    -- Prefix match
    if target:sub(1, #query) == query then
        return true, 5000 + (100 - #target)
    end

    -- Substring match (not at start)
    if target:find(query, 1, true) then
        return true, 1000
    end

    -- Set default variables
    local score = 0
    local queryIndex = 1
    local lastMatchPosition = -1
    local consecutive = 0

    -- For index in target do
    for targetIndex = 1, #target do 
        -- Our character we are currently on
        local character = target:sub(targetIndex, targetIndex)

        -- matches query index?
        if character == query:sub(queryIndex, queryIndex) then
            
            -- consecutive
            if lastMatchPosition == targetIndex - 1 then
                consecutive += 1
                score += 10 * consecutive
            else 
                consecutive = 0
                score += 1
            end

            -- Char behind us
            local prevChar = target:sub(targetIndex - 1, targetIndex - 1)

            -- Increase our score by 20 if at word boundary
            if targetIndex == 1 or prevChar == " " or prevChar == "_" then
                score += 20
            end

            lastMatchPosition = targetIndex
            queryIndex += 1

            -- Have we matched each char in query?
            if queryIndex > #query then 
                score += math.max(0, 50 - targetIndex)
                return true, score
            end
        end
    end

    return false, 0
end

return utiltiesModules