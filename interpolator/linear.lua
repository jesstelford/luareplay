--- Default interpolator
-- Returns a function pointer to be passed to the Recorder
-- expects Ids and all values of Frames to be numbers
return (function(lastFrameId, requestedFrameId, nextFrameId, lastFrame, nextFrame)

    assert(type(lastFrameId) == 'number', 'Frame IDs must be numbers for Linear Interpolation')
    assert(type(requestedFrameId) == 'number', 'Frame IDs must be numbers for Linear Interpolation')
    assert(type(nextFrameId) == 'number', 'Frame IDs must be numbers for Linear Interpolation')

    local interpolatePercentage = (requestedFrameId - lastFrameId) / (nextFrameId - lastFrameId)

    local result = {}

    for key, value in pairs(lastFrame) do
        assert(nextFrame[key] ~= nil, 'Next Frame must contain same keys as Last Frame when using Linear Interpolation')
        assert(type(value) == 'number' and type(nextFrame[key]) == 'number', 'All Frame values must be numbers for Linear Interpolation')
        result[key] = lastFrame[key] + ((nextFrame[key] - lastFrame[key]) * interpolatePercentage)
    end

    return result
end)
