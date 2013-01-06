return (function()
    
    local me = {}

    local recordings = {}

    function me:record(id, recordable)
        assert(recordings[id] == nil, 'id must be unique, for example; a timestamp')
        assert(recordable.serialize, "object must have a serialize method, for example; a 'recordable'")
        recordings[id] = recordable:serialize()
    end

    function me:getRecording(id)
        return recordings[id]
    end

    return me

end)
