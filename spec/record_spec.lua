require "spec.bootstrap"

describe('table recording module #record', function()

    it('contains serialize method when created', function()
        local object = require "recordable"({})
        assert.has_method(object, 'serialize')
    end)

    it('adds serialize method when extending', function()
        local object = {}
        object = require "recordable"(object)
        assert.has_method(object, 'serialize')
    end)

    it('modifies the original object', function()
        local object = {}
        require "recordable"(object)
        assert.has_method(object, 'serialize')
    end)

    it('throws error when serialize already exists', function()
        local object = {serialize = 1}
        assert.has_error(function() require "recordable"(object) end)
    end)

    it('throws error when whitelist not table', function()
        assert.has_error(function() require "recordable"({}, function() end) end)
        assert.has_error(function() require "recordable"({}, "foo") end)
        assert.has_error(function() require "recordable"({}, true) end)
    end)

    it('accepts empty whitelist table', function()
        local object = {}
        assert.has_no.errors(function() require "recordable"(object, {}) end)
    end)

    it('accepts whitelist table', function()
        local object = {}
        assert.has_no.errors(function() require "recordable"(object, {x = true}) end)
    end)

    it('returns a table when serialized', function()
        local recordable = require "recordable"
        local object = recordable({})
        local serialized = object.serialize()
        assert.is_equal(type(serialized), 'table')
    end)

    it('returns only nil, boolean, number, string, table types when serialized', function()

        local recordable = require "recordable"

        local object = recordable(
            {
                foo = 'bar',
                [true] = false,
                [1] = 0,
                [2] = nil,
                tab = {},
                nofunc = function() end
            }
        )

        local serialized = object.serialize()

        assert.are.same(
            {
                foo = 'bar',
                [true] = false,
                [1] = 0,
                [2] = nil,
                tab = {}
            },
            serialized
        )

    end)

    it('returns only boolean, number, string keys when serialized', function()

        local recordable = require "recordable"

        local object = recordable(
            {
                foo = 'bar',
                [true] = false,
                [1] = 0,
                ['bar'] = nil,
                [{}] = 'a table',
                [function() end] = 'a func'
            }
        )

        local serialized = object.serialize()

        assert.are.same(
            {
                foo = 'bar',
                [true] = false,
                [1] = 0,
                ['bar'] = nil
            },
            serialized
        )

    end)

    it('returns only whitelisted params when serialized', function()

        local recordable = require "recordable"

        local whitelist = {
            foo = true,
            [1] = true
        }

        local object = recordable(
            {
                foo = 'bar',
                [true] = false,
                [1] = 0,
                [2] = nil,
                tab = {},
                nofunc = function() end
            },
            whitelist
        )

        local serialized = object.serialize()

        assert.are.same(
            {
                foo = 'bar',
                [1] = 0
            },
            serialized
        )


    end)

    it('returns nested tables when serialized', function()

        local recordable = require "recordable"

        local object = recordable(
            {
                tab = {
                    foo = 'bar'
                }
            }
        )

        local serialized = object.serialize()

        assert.are.same(
            {
                tab = {
                    foo = 'bar'
                }
            },
            serialized
        )

    end)

end)

describe('recording modifications to table', function()



end)
