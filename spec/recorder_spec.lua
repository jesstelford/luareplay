require "spec.bootstrap"

describe('recorder module #record', function()

    local Recorder = require "recorder"()

    it('has a record method', function()
        assert.has_method(Recorder, 'record')
    end)

    it('has a getRecording method', function()
        assert.has_method(Recorder, 'getRecording')
    end)

end)

describe('recorder record method #record', function()

    it('only accepts unique IDs', function()
        local Recorder = require "recorder"()
        local object = require "recordable"({})
        Recorder:record(1, object)
        assert.has_error(function() Recorder:record(1, object) end)
    end)

    it('can record the same object multiple times', function()
        local Recorder = require "recorder"()
        local object = require "recordable"({})
        Recorder:record('abc', object)
        Recorder:record(1, object)
    end)

end)

describe('recorder getRecording method #record', function()

    it('correctly returns recorded table', function()
        local Recorder = require "recorder"()
        local object = require "recordable"({})
        
        Recorder:record(1, object)

        local serialized = object:serialize();
        local recording = Recorder:getRecording(1)

        assert.are.same(recording, serialized)
    end)

end)
