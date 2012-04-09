module(..., package.seeall);

local _log = nil

function print(message)
    if _log == nil then
        _log = '' .. message
    else
        _log = _log .. '\n' .. message
    end
end

function messages()
    return _log or ''
end
