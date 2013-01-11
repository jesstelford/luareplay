return (function()
    
    local recordings = {}

    local function defaultPlaybackInterpolator(lastFrameId, requestedFrameId, nextFrameId, lastFrame, nextFrame)
        return nextFrame
    end

    local me = {
        playbackInterpolator = defaultPlaybackInterpolator,
        greaterThan = nil
    }

    local function initGroup(group)
        -- default group
        group = group or 'global'
        assert(group == nil or type(group) == 'string', "group must be a string name, or nil for default ('global' group)");

        -- create the group if not exist
        recordings[group] = recordings[group] or {
            indexToId = {},
            byId = {} -- array of tables: {recording, index}
        }

        return group
    end

    function me:setGreaterThanComparison(greaterThan)
        assert(type(greaterThan) == 'function', 'Must be a method which accepts a left and right hand value of the > operator, and returns a boolean')
        self.greaterThan = greaterThan
    end

    function me:setInterpolationMethod(interpolator)
        assert(type(interpolator) == 'function', 'Must be a method which interpolates between recordings and returns the result')
        self.playbackInterpolator = interpolator
    end

    --- Take a snapshot recording of the given object
    -- @param id(mixed) The id to store the recording under
    -- @param recordable(table) The item to record. Must have a 'serialize' method
    -- @param group(string) The group to store recoding under. Default: 'global'
    function me:record(id, recordable, group)

        assert(id ~= nil, 'id must be set')

        group = initGroup(group)

        assert(recordings[group].byId[id] == nil, 'id must be unique, for example; a timestamp')

        -- check the object has the correct method
        assert(type(recordable.serialize) == 'function', "object must have a serialize method, for example; a 'recordable'")

        -- Set the id into the index table
        table.insert(recordings[group].indexToId, id)

        -- actually perform the recording
        recordings[group].byId[id] = {
            recording = recordable:serialize(),
            index = #recordings[group].indexToId -- the count of items is the same as the highest index for numerically keyed tables
        }
    end

    --- Get a snapshot of a recording
    -- @param id(mixed) The id the recording was stored under
    -- @param group(string) The group the recoding was stored under. Default: 'global'
    -- @return table The item recorded.
    function me:getRecording(id, group)

        assert(id ~= nil, 'id must be set')
        group = initGroup(group)

        if recordings[group].byId[id] ~= nil then
            return recordings[group].byId[id].recording
        end

        return nil
    end

    --- Get a snapshot of the next recording
    -- @param id(mixed) The id of the previous recording
    -- @param group(string) The group the recoding was stored under. Default: 'global'
    -- @return table The item recorded.
    function me:getRecordingAfter(id, group)

        assert(id ~= nil, 'id must be set')
        group = initGroup(group)

        if recordings[group].byId[id] ~= nil then
            local index = recordings[group].byId[id].index
            local nextId = recordings[group].indexToId[index + 1]

            if nextId ~= nil then
                return recordings[group].byId[nextId].recording
            end
        end

        return nil
    end

    --- Playback the recording, passing values through to an interpolation
    -- method if exact Id not found
    -- @param desiredFrameId(mixed) The frameId you want to playback
    -- @param nextFrameId(mixed|nil) The next recorded Key Frame Id (such as returned from previous calls to playback())
    -- @return nextFrameId, recording
    function me:playback(desiredFrameId, nextFrameId, group)

        -- default to the first recorded id
        group = initGroup(group)

        local recordGroup = recordings[group]

        assert(desiredFrameId ~= nil, 'desiredFrameId must be set')
        assert(self.greaterThan ~= nil, 'greater than comparison method must be set')
        assert(#recordGroup.indexToId > 0, 'Must be at least one recording to play back')

        local desiredFrame = recordGroup.byId[desiredFrameId]

        if desiredFrame ~= nil then
            -- if the desired keyframe exists, return it regardless of
            -- nextFrameId value
            local nextFrameIndex = desiredFrame.index
            local nextId = recordGroup.indexToId[nextFrameIndex + 1]

            return nextId, desiredFrame.recording
        end

        nextFrameId = nextFrameId or recordGroup.indexToId[1]

        if recordGroup.indexToId[1] == nextFrameId and self.greaterThan(nextFrameId, desiredFrameId) then

            -- there is no previous frame (aka; 'nextFrame' is the first frame)
            -- and the desired frame is 'less than or equal' to the first frame
            local firstFrame = recordGroup.byId[nextFrameId]
            local secondFrameId = recordGroup.indexToId[firstFrame.index + 1]

            -- so just return the first frame
            return secondFrameId, firstFrame.recording

        else
            local lastFrameId = recordGroup.indexToId[#recordGroup.indexToId]
            if self.greaterThan(desiredFrameId, lastFrameId) then
                -- there are no more frames, so return the last along with nil for
                -- 'nextid'
                return nil, recordGroup.byId[lastFrameId].recording
            end
        end

        local lastFrameIndex = recordGroup.byId[nextFrameId].index - 1
        local lastFrameId = recordGroup.indexToId[lastFrameIndex]

        -- now we know we need to interpolate, and that desiredFrameId is
        -- 'greater than' the first frame.
        -- But first, we need to find the two ids between which to
        -- interpolate.
        -- So, we take advantage of the temporal nature of recordings and
        -- search either forward or backward from the lsat known point.

        if self.greaterThan(desiredFrameId, nextFrameId) then
            -- search forward for next ids
            local nextFrameIndex = recordGroup.byId[nextFrameId].index
            
            repeat 
                -- save 'last' values
                lastFrameIndex = nextFrameIndex
                lastFrameId = nextFrameId

                -- calculate 'next' values
                nextFrameId = recordGroup.indexToId[lastFrameIndex + 1]
                nextFrameIndex = recordGroup.byId[nextFrameId].index
            until not self.greaterThan(desiredFrameId, nextFrameId)

        elseif self.greaterThan(lastFrameId, desiredFrameId) then

            -- search backward for next ids
            repeat 
                -- save 'next' values
                nextFrameIndex = lastFrameIndex
                nextFrameId = lastFrameId

                -- calculate 'last' values
                lastFrameId = recordGroup.indexToId[nextFrameIndex - 1]
                lastFrameIndex = recordGroup.byId[lastFrameId].index
            until not self.greaterThan(lastFrameId, desiredFrameId)

        end

        local lastRecording = self:getRecording(lastFrameId, group)
        local nextRecording = self:getRecordingAfter(nextFrameId, group)

        if lastRecording ~= nil then
            lastRecording = lastRecording.recording
        end

        if nextRecording ~= nil then
            nextRecording = nextRecording.recording
        end

        return nextFrameId, self.playbackInterpolator(
            lastFrameId,
            desiredFrameId,
            nextFrameId,
            lastRecording,
            nextRecording
        )

    end

    return me

end)
