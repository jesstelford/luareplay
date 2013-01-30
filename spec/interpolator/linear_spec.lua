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

    pending('Only accepts table for lastFrame', function()
    end)

    pending('Only accepts table for nextFrame', function()
    end)
end)

describe('Frame values are number assertions', function()
    
    pending('Has error when a frame value is not a number', function()
    end)

    pending('Has no errors when all frame values are numbers', function()
    end)

end)

describe('Frame keys exist in both frames assertions', function()
    
    pending('Has error when frame key exists in lastFrame, but not nextFrame', function()
    end)
    
    pending('Has error when frame key exists in nextFrame, but not lastFrame', function()
    end)

end)

describe('Linear Interpolation assertions', function()
    
    pending('Interpolates Linearly', function()
    end)

    pending('Interpolates Linearly when nextFrame values are less than lastFrame values', function()
    end)

    pending('Returns the same Frame when both last and next Frames are identical', function()
    end)

end)
