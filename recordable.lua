local serialize = require("serpent.src.serpent").dump

return (function(me)
    
    assert(me.serialize == nil, "'record' method already exists on " .. tostring(me))

    me.serialize = function()
        return serialize(me)
    end

    return me
end)
