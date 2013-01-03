local s = require("say")

-- register the has_method assertion
local function has_method(state, arguments)
    local has_key = false

    if not type(arguments[1]) == "table" or #arguments ~= 2 then
        return false
    end

    for key, value in pairs(arguments[1]) do
        if key == arguments[2] then
            has_key = true
            break
        end
    end

    -- state.mod holds true or false, which is true normally, or false if we
    -- are negating the assertion by using is_not or one of its aliases.

    return state.mod == has_key
end

s:set("en", "assertion.has_method.positive", "Expected method %s in:\n%s")
s:set("en", "assertion.has_method.negative", "Expected method %s to not be in:\n%s")
assert:register("assertion", "has_method", has_method, "assertion.has_method.positive", "assertion.has_method.negative")

-- register the has_property assertion
local function has_property(state, arguments)
    local has_key = false

    if not type(arguments[1]) == "table" or #arguments ~= 2 then
        return false
    end

    for key, value in pairs(arguments[1]) do
        if key == arguments[2] then
            has_key = true
            break
        end
    end

    -- state.mod holds true or false, which is true normally, or false if we
    -- are negating the assertion by using is_not or one of its aliases.

    return state.mod == has_key
end

s:set("en", "assertion.has_property.positive", "Expected property %s in:\n%s")
s:set("en", "assertion.has_property.negative", "Expected property %s to not be in:\n%s")
assert:register("assertion", "has_property", has_property, "assertion.has_property.positive", "assertion.has_property.negative")
