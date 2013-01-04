
return (function(me, serpent, whitelist)
    
    assert(serpent.dump, 'serpent library must be present')
    assert(whitelist == nil or type(whitelist) == 'table', 'whitelist must be a table of properties to record')
    assert(me.serialize == nil, "'record' method already exists on " .. tostring(me))

    local serpentOptions = {}

    -- only set whitelist if options passed in
    for k,v in pairs(whitelist or {}) do
        serpentOptions.keyallow = whitelist
        break
    end

    me.serialize = function()
        return loadstring(serpent.dump(me, serpentOptions))()
    end

    return me
end)
