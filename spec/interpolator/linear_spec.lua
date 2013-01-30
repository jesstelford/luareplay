require "spec.bootstrap"

describe('ID is number assertions', function()

    pending('Only accepts number ID for lastFrameId', function()
    end)

    pending('Only accepts number ID for requestedFrameId', function()
    end)

    pending('Only accepts number ID for nextFrameId', function()
    end)

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
