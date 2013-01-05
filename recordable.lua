return (function(me, whitelist)
    
    assert(whitelist == nil or type(whitelist) == 'table', 'whitelist must be a table of properties to record')
    assert(me.serialize == nil, "'record' method already exists on " .. tostring(me))

    -- we don't want to serialize any of the below types
    local valtypeignore = {
        ['function'] = true,
        ['userdata'] = true,
        ['thread'] = true
    }

    -- we don't want to serialize any of the below types
    local keytypeignore = {
        ['function'] = true,
        ['userdata'] = true,
        ['thread'] = true,
        ['table'] = true
    }

    local function serialize(theTable)

        local out = {}

        for key, value in pairs(theTable) do
            if
                ((not whitelist) or whitelist[key])
                and (not valtypeignore[type(value)])
                and (not keytypeignore[type(key)])
            then
                if type(value) == 'table' then
                    out[key] = serialize(value)
                else
                    out[key] = value
                end
            end
        end

        return out
        
    end

    me.serialize = function()
        return serialize(me)
    end

    return me
end)
