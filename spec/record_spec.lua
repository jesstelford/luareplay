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

    it('throws error when whitelist not table', function()
        assert.has_error(function() require "recordable"({}, serpent, function() end) end)
        assert.has_error(function() require "recordable"({}, serpent, "foo") end)
        assert.has_error(function() require "recordable"({}, serpent, true) end)
    end)

    it('accepts empty whitelist table', function()
        local object = {}
        assert.has_no.errors(function() require "recordable"(object, serpent, {}) end)
    end)

    it('accepts whitelist table', function()
        local object = {}
        assert.has_no.errors(function() require "recordable"(object, serpent, {x = true}) end)
    end)

    it('returns a table when serialized', function()
        local recordable = require "recordable"
        local object = recordable({}, serpent)
        local serialized = object.serialize()
        assert.is_equal(type(serialized), 'table')
    end)

    pending('returns all params by default when serialized', function()

        local recordable = require "recordable"

        local object = recordable(
            {
                foo = 'bar',
                [true] = false,
                [1] = 0
            },
            serpent
        )

        local serialized = object.serialize()

        assert.are.same(serialized, object)

    end)

    it('returns only whitelisted params by default when serialized', function()

        local recordable = require "recordable"

        local object = {
            foo = 'bar',
            [true] = false,
            [1] = 0
        }

        local serialized = recordable(object, serpent)
        assert.are.same(serialized, object)

    end)

end)

describe('recording modifications to table', function()



end)
