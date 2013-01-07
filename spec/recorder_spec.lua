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
        local object = require "recordable"({})
        
        Recorder:record(1, object, 'foo')

        local serialized = object:serialize();
        local recording = Recorder:getRecording(1, 'foo')

        assert.are.same(recording, serialized)
    end)

    it('returns correct recording with same id as recording in another group', function()
        local Recorder = require "recorder"()
        local objectFoo = require "recordable"({})
        local objectBar = require "recordable"({})
        
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
        local objectFoo = require "recordable"({})
        local objectBar = require "recordable"({})
        
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

    describe('id parameter', function()

        local Recorder = require "recorder"()

        it('accepts number IDs', function()
            assert.has_no.errors(function() Recorder:playback(1) end)
        end)

        it('accepts bool IDs', function()
            assert.has_no.errors(function() Recorder:playback(true) end)
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

    describe('group parameter', function()

        local Recorder = require "recorder"()

        it('accepts string group name', function()
            assert.has_no.errors(function() Recorder:playback(1, 'foo') end)
        end)

        it('doesnt accept number group name', function()
            assert.has_error(function() Recorder:playback(1, 1) end)
        end)

        it('doesnt accept boolean group name', function()
            assert.has_error(function() Recorder:playback(1, true) end)
        end)

        it('doesnt accept table group name', function()
            assert.has_error(function() Recorder:playback(1, {}) end)
        end)

        it('doesnt accept function group name', function()
            assert.has_error(function() Recorder:playback(1, function() end) end)
        end)

    end)

    describe('stepFraction parameter', function()

        local Recorder = require "recorder"()

        it('accepts number fraction', function()
            assert.has_no.errors(function() Recorder:playback(1, 'foo', 1.0) end)
        end)

        it('accepts nil fraction', function()
            assert.has_no.errors(function() Recorder:playback(1, 'foo', nil) end)
        end)

        it('accepts false fraction', function()
            assert.has_no.errors(function() Recorder:playback(1, 'foo', false) end)
        end)

        it('doesnt accept string fraction', function()
            assert.has_error(function() Recorder:playback(1, 'foo', 'bar') end)
        end)

        it('doesnt accept boolean fraction', function()
            assert.has_error(function() Recorder:playback(1, 'foo', true) end)
        end)

        it('doesnt accept table fraction', function()
            assert.has_error(function() Recorder:playback(1, 'foo', {}) end)
        end)

        it('doesnt accept function fraction', function()
            assert.has_error(function() Recorder:playback(1, 'foo', function() end) end)
        end)

    end)

end)
