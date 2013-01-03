require "spec.bootstrap"

describe('table recording module #record', function()

    it('contains record method when created', function()

        local object = require "recordable"({})
        assert.has_method(object, 'record')

    end)

    it('adds record method when created', function()

        local object = {}
        object = require "recordable"(object)
        assert.has_method(object, 'record')

    end)

    it('modifies the original object', function()

        local object = {}
        require "recordable"(object)
        assert.has_method(object, 'record')

    end)

    it('throws error when record already exists', function()
        local recordable = require "recordable"
        local object = {record = 1}
        assert.has_error(function() recordable(object) end)

    end)

end)
