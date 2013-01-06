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

end)

describe('recorder getRecording method #record', function()

    it('correctly returns recorded table', function()
        local Recorder = require "recorder"()
        local object = require "recordable"({})
        
        Recorder:record(1, object, 'foo')

        local serialized = object:serialize();
        local recording = Recorder:getRecording(1, 'foo')

        assert.are.same(recording, serialized)
    end)

end)
