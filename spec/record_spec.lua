require "spec.bootstrap"

describe('table recording #record', function()
    it('contains record method', function()

        local object = require "recordable"({})
        assert.has_method(object, 'record')

    end)
end)
