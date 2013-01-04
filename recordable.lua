
return (function(me, serpent)
    
    assert(serpent.dump, 'serpent library must be present')
    assert(me.serialize == nil, "'record' method already exists on " .. tostring(me))

    me.serialize = function()
        return serialize(me)
    end

    return me
end)
