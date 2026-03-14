local searchModule = {}

local utilityModule = require(script.Parent.utilities)

--// Search through all the commands!
function searchModule:search(query : string, commandList : {{title : string, callback: () -> ()}})
    -- If nil then return all
    if query == "" then
        return commandList
    end

    -- Default definitions
    local results = {}
    local sorted = {}

    -- fuzzy search through all the commands based on query
    for _, cmd in commandList do 
        local matched, score = utilityModule:fuzzySearch(query, cmd.title)
        if matched then
            table.insert(results, { cmd = cmd, score = score })
        end
    end

    -- Sort table based on score
    table.sort(results, function(a, b)
       return a.score > b.score
    end)

    -- Get all results and sort into results table
    for _, result in results do
        table.insert(sorted, result.cmd)
    end

    return sorted
end

return searchModule