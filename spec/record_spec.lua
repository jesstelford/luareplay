require "spec.bootstrap"

describe('table recording module #record', function()

    local serpent = require("serpent.src.serpent")

    it('contains serialize method when created', function()
        local object = require "recordable"({}, serpent)
        assert.has_method(object, 'serialize')
    end)

    it('adds serialize method when extending', function()
        local object = {}
        object = require "recordable"(object, serpent)
        assert.has_method(object, 'serialize')
    end)

    it('modifies the original object', function()
        local object = {}
        require "recordable"(object, serpent)
        assert.has_method(object, 'serialize')
    end)

    it('throws error when serialize already exists', function()
        local object = {serialize = 1}
        assert.has_error(function() require "recordable"(object, serpent) end)
    end)

end)

describe('recording modifications to table', function()



end)
