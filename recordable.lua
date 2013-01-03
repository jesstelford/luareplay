return (function(me)
    
    assert(me.record == nil, "'record' method already exists on " .. tostring(me))

    me.record = function()

    end

    return me
end)
