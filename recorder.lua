return (function()
    
    local me = {}

    local recordings = {}

    function me:record(id, recordable)
        assert(recordings[id] == nil, 'id must be unique, for example; a timestamp')
        recordings[id] = recordable.serialize()
    end

    function me:getRecording(id)
        return recordings[id]
    end

    return me

end)
