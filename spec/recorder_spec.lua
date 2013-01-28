require "spec.bootstrap"

describe('recorder module #record', function()

    local Recorder = require "recorder"()

    it('has a record method', function()
        assert.has_method(Recorder, 'record')
    end)

    it('has a getRecording method', function()
        assert.has_method(Recorder, 'getRecording')
    end)

    it('has a getRecordingAfter method', function()
        assert.has_method(Recorder, 'getRecordingAfter')
    end)

    it('has a playback method', function()
        assert.has_method(Recorder, 'playback')
    end)

end)

describe('recorder record method #record', function()

    describe('id parameter', function()

        for _, data in pairs({
            {name = 'accepts number IDs', value = 1},
            {name = 'accepts bool IDs', value = true},
            {name = 'accepts string IDs', value = 'foo'},
            {name = 'accepts table IDs', value = {}},
            {name = 'accepts function IDs', value = function() end},
        }) do
            it(data.name, function()
                local Recorder = require "recorder"()
                local object = require "recordable"({})
                assert.has_no.errors(function() Recorder:record(data.value, object) end)
            end)
        end

        it('only accepts unique IDs', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            Recorder:record(1, object)
            assert.has_error(function() Recorder:record(1, object) end)
        end)

    end)

    describe('group parameter', function()

        it('accepts string group name', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            assert.has_no.errors(function() Recorder:record(1, object, 'foo') end)
        end)

        for _, data in pairs({
            {name = 'doesnt accept number group name', value = 1},
            {name = 'doesnt accept bool group name', value = true},
            {name = 'doesnt accept table group name', value = {}},
            {name = 'doesnt accept function group name', value = function() end},
        }) do
            it(data.name, function()
                local Recorder = require "recorder"()
                local object = require "recordable"({})
                assert.has_error(function() Recorder:record(1, object, data.value) end)
            end)
        end

    end)

    it('checks for serialize method on recordable object', function()
        local Recorder = require "recorder"()
        local object = {}
        assert.has_error(function() Recorder:record(1, object) end)
    end)

    it('can record the same object multiple times', function()
        local Recorder = require "recorder"()
        local object = require "recordable"({})
        Recorder:record('abc', object)
        assert.has_no.errors(function() Recorder:record(1, object) end)
    end)

    it('can set same id in different groups', function()
        local Recorder = require "recorder"()
        local object = require "recordable"({})
        Recorder:record(1, object, 'foo')
        assert.has_no.errors(function() Recorder:record(1, object, 'bar') end)
    end)

end)

describe('recorder getRecording method #record', function()

    describe('group parameter', function()

        it('accepts string group name', function()
            local Recorder = require "recorder"()
            assert.has_no.errors(function() Recorder:getRecording(1, 'foo') end)
        end)

        for _, data in pairs({
            {name = 'doesnt accept number group name', value = 1},
            {name = 'doesnt accept bool group name', value = true},
            {name = 'doesnt accept table group name', value = {}},
            {name = 'doesnt accept function group name', value = function() end},
        }) do
            it(data.name, function()
                local Recorder = require "recorder"()
                assert.has_error(function() Recorder:getRecording(1, data.value) end)
            end)
        end

    end)

    it('correctly returns recorded table', function()
        local Recorder = require "recorder"()
        local object = require "recordable"({name = 'Foo'})
        
        Recorder:record(1, object, 'foo')

        local serialized = object:serialize();
        local recording = Recorder:getRecording(1, 'foo')

        assert.are.same(recording, serialized)
    end)

    it('returns correct recording with same id as recording in another group', function()
        local Recorder = require "recorder"()
        local objectFoo = require "recordable"({name = 'Foo'})
        local objectBar = require "recordable"({name = 'Bar'})
        
        Recorder:record(1, objectFoo, 'foo')
        Recorder:record(1, objectBar, 'bar')

        local serializedFoo = objectFoo:serialize();
        local serializedBar = objectBar:serialize();

        local recordingFoo = Recorder:getRecording(1, 'foo')
        local recordingBar = Recorder:getRecording(1, 'bar')

        assert.are.same(recordingFoo, serializedFoo)
        assert.are.same(recordingBar, serializedBar)
    end)

    it('returns nil for non-existing recording', function()
        local Recorder = require "recorder"()
        assert.is.equal(nil, Recorder:getRecording(1))
    end)

    it('returns nil for non-existing recording in given group', function()
        local Recorder = require "recorder"()
        local object = require "recordable"({})
        
        Recorder:record(1, object, 'foo')

        assert.is.equal(nil, Recorder:getRecording(1, 'bar'))
    end)

end)

describe('recorder getRecordingAfter method #record', function()

    describe('group parameter', function()

        it('accepts string group name', function()
            local Recorder = require "recorder"()
            assert.has_no.errors(function() Recorder:getRecordingAfter(1, 'foo') end)
        end)

        for _, data in pairs({
            {name = 'doesnt accept number group name', value = 1},
            {name = 'doesnt accept bool group name', value = true},
            {name = 'doesnt accept table group name', value = {}},
            {name = 'doesnt accept function group name', value = function() end},
        }) do
            it(data.name, function()
                local Recorder = require "recorder"()
                assert.has_error(function() Recorder:getRecordingAfter(1, data.value) end)
            end)
        end

    end)

    it('correctly returns recorded table inserted after', function()
        local Recorder = require "recorder"()
        local objectFoo = require "recordable"({name = 'Foo'})
        local objectBar = require "recordable"({name = 'Bar'})
        
        Recorder:record('foo', objectFoo)
        Recorder:record('bar', objectBar)

        local serializedBar = objectBar:serialize();

        local recordingBar = Recorder:getRecordingAfter('foo')

        assert.are.same(recordingBar, serializedBar)
    end)

    it('returns nil for empty recording list', function()
        local Recorder = require "recorder"()
        assert.is.equal(nil, Recorder:getRecordingAfter(1))
    end)

    it('returns nil for empty recording list in given group', function()
        local Recorder = require "recorder"()
        local object = require "recordable"({})
        
        Recorder:record(1, object, 'foo')

        assert.is.equal(nil, Recorder:getRecordingAfter(1, 'bar'))
    end)

    it('returns nil for next empty recording list', function()
        local object = require "recordable"({})
        local Recorder = require "recorder"()

        Recorder:record(1, object)

        assert.is.equal(nil, Recorder:getRecordingAfter(1))
    end)

    it('returns nil for next empty recording list in group', function()
        local Recorder = require "recorder"()
        local object = require "recordable"({})
        
        Recorder:record(1, object, 'foo')

        assert.is.equal(nil, Recorder:getRecordingAfter(1, 'foo'))
    end)

end)

describe('recorder playback method #record', function()

    describe('desiredFrameId parameter', function()

        local Recorder = require "recorder"()
        local object = require "recordable"({name = 'Baz'})
        Recorder:setGreaterThanComparison(function() return true end)
        Recorder:record(1, object)

        it('is required', function()
            assert.has_error(function() Recorder:playback() end)
        end)

        it('doesnt accept nil', function()
            assert.has_error(function() Recorder:playback(nil) end)
        end)

        for _, data in pairs({
            {name = 'accepts number IDs', value = 1},
            {name = 'accepts string IDs', value = 'foo'},
            {name = 'accepts bool IDs', value = true},
            {name = 'accepts table IDs', value = {}},
            {name = 'accepts function IDs', value = function() end},
        }) do
            it(data.name, function()
                assert.has_no.errors(function() Recorder:playback(data.value) end)
            end)
        end

    end)

    describe('nextFrameId parameter', function()

        local Recorder = require "recorder"()
        local object = require "recordable"({name = 'Baz'})
        Recorder:setGreaterThanComparison(function() return true end)
        Recorder:record(1, object)

        for _, data in pairs({
            {name = 'accepts number IDs', value = 1},
            {name = 'accepts string IDs', value = 'foo'},
            {name = 'accepts bool IDs', value = true},
            {name = 'accepts table IDs', value = {}},
            {name = 'accepts function IDs', value = function() end},
        }) do
            it(data.name, function()
                assert.has_no.errors(function() Recorder:playback(1, data.value) end)
            end)
        end

    end)

    describe('group parameter', function()

        local Recorder = require "recorder"()
        local object = require "recordable"({name = 'Baz'})
        Recorder:setGreaterThanComparison(function() return true end)

        it('accepts string group name', function()
            Recorder:record(1, object, 'foo')
            assert.has_no.errors(function() Recorder:playback(1, 1, 'foo') end)
        end)

        for _, data in pairs({
            {name = 'doesnt accept number IDs', value = 1},
            {name = 'doesnt accept bool IDs', value = true},
            {name = 'doesnt accept table IDs', value = {}},
            {name = 'doesnt accept function IDs', value = function() end},
        }) do
            it(data.name, function()
                assert.has_error(function() Recorder:playback(1, 1, data.value) end)
            end)
        end

    end)

    describe('pre-conditions before usage', function()


        it('expects greater than method to be set', function()
            local Recorder = require "recorder"()
            local objectBar = require "recordable"({name = 'Bar'})
            Recorder:record(1, objectBar)
            assert.has_error(function() Recorder:playback(1, 1) end)
        end)

        it('expects at least one recording', function()
            local Recorder = require "recorder"()
            Recorder:setGreaterThanComparison(function() return true end)
            assert.has_error(function() Recorder:playback(1, 1) end)
        end)

    end)

    describe('default interpolation method', function()

        local Recorder = require "recorder"()

        it('returns next frame', function()
            result = Recorder.playbackInterpolator(1, 2, 3, 4, 5)
            assert.equals(5, result)
        end)

    end)

    describe('usage', function()

        local Recorder = require "recorder"()

        local objectFoo = require "recordable"({name = 'Foo'})
        local objectBar = require "recordable"({name = 'Bar'})
        local objectBaz = require "recordable"({name = 'Baz'})
        
        Recorder:record(1, objectFoo)
        Recorder:record(4, objectBar)
        Recorder:record(5, objectBaz)

        Recorder:setGreaterThanComparison(function(left, right)
            return left > right
        end)

        describe('return values', function()

            for _, data in pairs({
                {name = 'returns the frame if the id exists', values = {4, nil, objectBar:serialize()}},
                {name = 'returns the first frame when desired id not greater than first id', values = {0, nil, objectFoo:serialize()}},
                {name = 'returns the first frame when desired id not greater than first id and nextid set to first id', values = {0, 1, objectFoo:serialize()}},
                {name = 'returns the last frame when desired id greater than last id', values = {10, nil, objectBaz:serialize()}},
            }) do
                it(data.name, function()
                    nextFrameId, recording = Recorder:playback(data.values[1], data.values[2])
                    assert.are_same(data.values[3], recording)
                end)
            end

            for _, data in pairs({
                {name = 'returns the next id if the frame exists and id is null', values = {4, nil, 5}},
                {name = 'returns the next id if the frame exists and id is in future', values = {1, 5, 4}},
                {name = 'returns the next id if the frame exists and id is in past', values = {4, 1, 5}},
                {name = 'returns the second frame id as next id when desired id not greater than first id', values = {0, nil, 4}},
                {name = 'returns the second frame id as next id when desired id not greater than first id and nextid set to first id', values = {0, 1, 4}},
                {name = 'returns the nil for frame id as next id when desired id greater than last id', values = {10, nil, nil}}
            }) do
                it(data.name, function()
                    nextFrameId, recording = Recorder:playback(data.values[1], data.values[2])
                    assert.equals(data.values[3], nextFrameId)
                end)
            end

        end)

    end)

    describe('interpolation', function()

        describe('calling interpolation', function()

            local Recorder = require "recorder"()

            local objectFoo = require "recordable"({name = 'Foo'})
            local objectBar = require "recordable"({name = 'Bar'})
            
            Recorder:record(1, objectFoo)
            Recorder:record(4, objectBar)

            -- setup the spy to track calls to this method
            spy.on(Recorder, "playbackInterpolator")

            Recorder:setGreaterThanComparison(function(left, right)
                return left > right
            end)

            after_each(function()
                Recorder.playbackInterpolator.calls = {} -- reset the spied calls
            end)

            it('calls interpolation method when desired frame id greater than nextframeid', function()
                Recorder:playback(2)
                assert.spy(Recorder.playbackInterpolator).was.called(1)
            end)

            it('calls interpolation method when desired frame id not greater than next frame id', function()
                Recorder:playback(2, 4)
                assert.spy(Recorder.playbackInterpolator).was.called(1)
            end)

            it('default interpolation method returns recording of next id', function()
                local nextFrameId, recording = Recorder:playback(2)
                local serialized = objectBar:serialize()
                assert.are.same(recording, serialized)
            end)

        end)

        describe('return value of interpolation', function()

            local Recorder = require "recorder"()

            local objectFoo = require "recordable"({name = 'Foo'})
            local objectBar = require "recordable"({name = 'Bar'})
            local objectBaz = require "recordable"({name = 'Baz'})
            local objectZip = require "recordable"({name = 'Zip'})
            
            Recorder:record(1, objectFoo)
            Recorder:record(4, objectBar)
            Recorder:record(5, objectBaz)
            Recorder:record(8, objectZip)

            Recorder:setGreaterThanComparison(function(left, right)
                return left > right
            end)

            Recorder:setInterpolationMethod(function(lastFrameId, requestedFrameId, nextFrameId, lastFrame, nextFrame)
                -- dummy return value
                return {called = true}
            end)

            -- setup the spy to track calls to this method
            spy.on(Recorder, "playbackInterpolator")

            -- after each test, reset the number of calls
            after_each(function()
                Recorder.playbackInterpolator.calls = {} -- reset the spied calls
            end)

            it('returns interpolation method when desired frame id greater than nextframeid', function()
                nextFrameId, recording = Recorder:playback(2)
                assert.are.same(recording, {called = true})
            end)

            it('returns interpolation method when desired frame id not greater than next frame id', function()
                nextFrameId, recording = Recorder:playback(2, 4)
                assert.are.same(recording, {called = true})
            end)

            it('interpolation method called with correct parameters when requested Id between first and second ids', function()
                nextFrameId, recording = Recorder:playback(2, 4)
                -- assert called with: (1, 2, 3, objectFoo, objectBar)
                assert.spy(Recorder.playbackInterpolator).was.called_with(1, 2, 4, objectFoo:serialize(), objectBar:serialize())
            end)

            it('interpolation method called with correct parameters when requested Id between middle ids', function()
                nextFrameId, recording = Recorder:playback(4.5, 5)
                -- assert called with: (4, 4.5, 5, objectBar, objectBaz)
                assert.spy(Recorder.playbackInterpolator).was.called_with(4, 4.5, 5, objectBar:serialize(), objectBaz:serialize())
            end)

            it('interpolation method called with correct parameters when requested Id between last and second last ids', function()
                nextFrameId, recording = Recorder:playback(6, 8)
                -- assert called with: (5, 6, 8, objectBaz, objectZip)
                assert.spy(Recorder.playbackInterpolator).was.called_with(5, 6, 8, objectBaz:serialize(), objectZip:serialize())
            end)

        end)

    end)

end)

