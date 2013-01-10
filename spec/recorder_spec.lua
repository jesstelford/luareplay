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

        it('accepts number IDs', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            assert.has_no.errors(function() Recorder:record(1, object) end)
        end)

        it('accepts bool IDs', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            assert.has_no.errors(function() Recorder:record(true, object) end)
        end)

        it('accepts string IDs', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            assert.has_no.errors(function() Recorder:record('foo', object) end)
        end)

        it('accepts table IDs', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            assert.has_no.errors(function() Recorder:record({}, object) end)
        end)

        it('accepts function IDs', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            assert.has_no.errors(function() Recorder:record(function() end, object) end)
        end)

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

        it('doesnt accept number group name', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            assert.has_error(function() Recorder:record(1, object, 1) end)
        end)

        it('doesnt accept boolean group name', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            assert.has_error(function() Recorder:record(1, object, true) end)
        end)

        it('doesnt accept table group name', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            assert.has_error(function() Recorder:record(1, object, {}) end)
        end)

        it('doesnt accept function group name', function()
            local Recorder = require "recorder"()
            local object = require "recordable"({})
            assert.has_error(function() Recorder:record(1, object, function() end) end)
        end)

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
        Recorder:record(1, object)
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

        it('doesnt accept number group name', function()
            local Recorder = require "recorder"()
            assert.has_error(function() Recorder:getRecording(1, 1) end)
        end)

        it('doesnt accept boolean group name', function()
            local Recorder = require "recorder"()
            assert.has_error(function() Recorder:getRecording(1, true) end)
        end)

        it('doesnt accept table group name', function()
            local Recorder = require "recorder"()
            assert.has_error(function() Recorder:getRecording(1, {}) end)
        end)

        it('doesnt accept function group name', function()
            local Recorder = require "recorder"()
            assert.has_error(function() Recorder:getRecording(1, function() end) end)
        end)

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

        it('doesnt accept number group name', function()
            local Recorder = require "recorder"()
            assert.has_error(function() Recorder:getRecordingAfter(1, 1) end)
        end)

        it('doesnt accept boolean group name', function()
            local Recorder = require "recorder"()
            assert.has_error(function() Recorder:getRecordingAfter(1, true) end)
        end)

        it('doesnt accept table group name', function()
            local Recorder = require "recorder"()
            assert.has_error(function() Recorder:getRecordingAfter(1, {}) end)
        end)

        it('doesnt accept function group name', function()
            local Recorder = require "recorder"()
            assert.has_error(function() Recorder:getRecordingAfter(1, function() end) end)
        end)

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

        it('accepts number IDs', function()
            assert.has_no.errors(function() Recorder:playback(1) end)
        end)

        it('accepts bool IDs', function()
            Recorder:playback(true)
        end)

        it('accepts string IDs', function()
            assert.has_no.errors(function() Recorder:playback('foo') end)
        end)

        it('accepts table IDs', function()
            assert.has_no.errors(function() Recorder:playback({}) end)
        end)

        it('accepts function IDs', function()
            assert.has_no.errors(function() Recorder:playback(function() end) end)
        end)

    end)

    describe('nextFrameId parameter', function()

        local Recorder = require "recorder"()
        local object = require "recordable"({name = 'Baz'})
        Recorder:setGreaterThanComparison(function() return true end)
        Recorder:record(1, object)

        it('accepts number IDs', function()
            assert.has_no.errors(function() Recorder:playback(1, 1) end)
        end)

        it('accepts bool IDs', function()
            assert.has_no.errors(function() Recorder:playback(1, true) end)
        end)

        it('accepts string IDs', function()
            assert.has_no.errors(function() Recorder:playback(1, 'foo') end)
        end)

        it('accepts table IDs', function()
            assert.has_no.errors(function() Recorder:playback(1, {}) end)
        end)

        it('accepts function IDs', function()
            assert.has_no.errors(function() Recorder:playback(1, function() end) end)
        end)

    end)

    describe('group parameter', function()

        local Recorder = require "recorder"()
        local object = require "recordable"({name = 'Baz'})
        Recorder:setGreaterThanComparison(function() return true end)

        it('accepts string group name', function()
            Recorder:record(1, object, 'foo')
            assert.has_no.errors(function() Recorder:playback(1, 1, 'foo') end)
        end)

        it('doesnt accept number group name', function()
            assert.has_error(function() Recorder:playback(1, 1, 1) end)
        end)

        it('doesnt accept boolean group name', function()
            assert.has_error(function() Recorder:playback(1, 1, true) end)
        end)

        it('doesnt accept table group name', function()
            assert.has_error(function() Recorder:playback(1, 1, {}) end)
        end)

        it('doesnt accept function group name', function()
            assert.has_error(function() Recorder:playback(1, 1, function() end) end)
        end)

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

        it('returns the frame if the id exists', function()
            nextFrameId, recording = Recorder:playback(4, nil)
            assert.are_same(recording, objectBar:serialize())
        end)

        it('returns the next id if the frame exists and id is null', function()
            nextFrameId, recording = Recorder:playback(4, nil)
            assert.are_same(5, nextFrameId)
        end)

        it('returns the next id if the frame exists and id is in future', function()
            nextFrameId, recording = Recorder:playback(1, 5)
            assert.are_same(4, nextFrameId)
        end)

        it('returns the next id if the frame exists and id is in past', function()
            nextFrameId, recording = Recorder:playback(4, 1)
            assert.are_same(5, nextFrameId)
        end)

    end)

end)
