return (function(me)
    
    if me.record ~= nil then
        error('record method already exists on ' .. me)
    end

    me.record = function()

    end

    return me
end)
