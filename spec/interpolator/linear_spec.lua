require "spec.bootstrap"

describe('ID is number assertions', function()

    local interpolator = require "interpolator.linear"

    it('Only accepts number IDs', function()
        assert.has_no.errors(function() interpolator(1, 1, 1, {}, {}) end)
    end)

    for _, data in pairs({
        {name = 'lastFrameId doesnt accept bool IDs', value = true},
        {name = 'lastFrameId doesnt accept string IDs', value = 'foo'},
        {name = 'lastFrameId doesnt accept table IDs', value = {}},
        {name = 'lastFrameId doesnt accept function IDs', value = function() end},
    }) do
        it(data.name, function()
            assert.has_error(function() interpolator(data.value, 1, 1, {}, {}) end)
        end)
    end

    for _, data in pairs({
        {name = 'requestedFrameId doesnt accept bool IDs', value = true},
        {name = 'requestedFrameId doesnt accept string IDs', value = 'foo'},
        {name = 'requestedFrameId doesnt accept table IDs', value = {}},
        {name = 'requestedFrameId doesnt accept function IDs', value = function() end},
    }) do
        it(data.name, function()
            assert.has_error(function() interpolator(1, data.value, 1, {}, {}) end)
        end)
    end

    for _, data in pairs({
        {name = 'nextFrameId doesnt accept bool IDs', value = true},
        {name = 'nextFrameId doesnt accept string IDs', value = 'foo'},
        {name = 'nextFrameId doesnt accept table IDs', value = {}},
        {name = 'nextFrameId doesnt accept function IDs', value = function() end},
    }) do
        it(data.name, function()
            assert.has_error(function() interpolator(1, 1, data.value, {}, {}) end)
        end)
    end

end)

describe('Frames are tables', function()

    local interpolator = require "interpolator.linear"

    it('Only accepts table frames', function()
        assert.has_no.errors(function() interpolator(1, 1, 1, {}, {}) end)
    end)

    for _, data in pairs({
        {name = 'lastFrame doesnt accept bool IDs', value = true},
        {name = 'lastFrame doesnt accept string IDs', value = 'foo'},
        {name = 'lastFrame doesnt accept number IDs', value = 1},
        {name = 'lastFrame doesnt accept function IDs', value = function() end},
    }) do
        it(data.name, function()
            assert.has_error(function() interpolator(1, 1, 1, data.value, {}) end)
        end)
    end

    for _, data in pairs({
        {name = 'nextFrame doesnt accept bool IDs', value = true},
        {name = 'nextFrame doesnt accept string IDs', value = 'foo'},
        {name = 'nextFrame doesnt accept number IDs', value = 1},
        {name = 'nextFrame doesnt accept function IDs', value = function() end},
    }) do
        it(data.name, function()
            assert.has_error(function() interpolator(1, 1, 1, {}, data.value) end)
        end)
    end

end)

describe('Frame values are number assertions', function()

    local interpolator = require "interpolator.linear"

    it('Only accepts frame values that are numbers', function()
        assert.has_no.errors(function() interpolator(1, 1, 1, {foo = 1}, {foo = 2}) end)
    end)

    for _, data in pairs({
        {name = 'has error when frame has bool value', value = true},
        {name = 'has error when frame has string value', value = 'foo'},
        {name = 'has error when frame has table value', value = {}},
        {name = 'has error when frame has function value', value = function() end},
    }) do
        it(data.name, function()
            assert.has_error(function() interpolator(1, 1, 1, {foo = data.value}, {foo = data.value}) end)
        end)
    end

end)

describe('Frame keys exist in both frames assertions', function()

    local interpolator = require "interpolator.linear"
    
    it('Has error when frame key exists in lastFrame, but not nextFrame', function()
        assert.has_error(function() interpolator(1, 1, 1, {foo = 1}, {}) end)
    end)
    
    it('Has error when frame key exists in nextFrame, but not lastFrame', function()
        assert.has_error(function() interpolator(1, 1, 1, {}, {foo = 1}) end)
    end)

end)

describe('Linear Interpolation assertions', function()
    pending('Interpolates Linearly', function()
    end)

    pending('Interpolates Linearly when nextFrame values are less than lastFrame values', function()
    end)

    pending('Returns the next Frame when both last and next Frames are identical', function()
    end)

end)
