return (function()
    
    local me = {}

    local recordings = {}

    local function initGroup(group)
        -- default group
        group = group or 'global'
        assert(group == nil or type(group) == 'string', "group must be a string name, or nil for default ('global' group)");

        -- create the group if not exist
        recordings[group] = recordings[group] or {}

        return group
    end

    --- Take a snapshot recording of the given object
    -- @param id(mixed) The id to store the recording under
    -- @param recordable(table) The item to record. Must have a 'serialize' method
    -- @param group(string) The group to store recoding under. Default: 'global'
    function me:record(id, recordable, group)

        assert(id ~= nil, 'id must be set')

        group = initGroup(group)

        assert(recordings[group][id] == nil, 'id must be unique, for example; a timestamp')

        -- check the object has the correct method
        assert(type(recordable.serialize) == 'function', "object must have a serialize method, for example; a 'recordable'")

        -- actually perform the recording
        recordings[group][id] = recordable:serialize()
    end

    --- Get a snapshot of a recording
    -- @param id(mixed) The id the recording was stored under
    -- @param group(string) The group the recoding was stored under. Default: 'global'
    -- @return table The item recorded.
    function me:getRecording(id, group)
        assert(id ~= nil, 'id must be set')
        group = initGroup(group)
        return recordings[group][id]
    end

    return me

end)
