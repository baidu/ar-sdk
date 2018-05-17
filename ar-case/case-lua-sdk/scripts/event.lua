-- event.lua --

EventDispatcher = {}

function EventDispatcher:init(o)
    o = o or {}
    o._listeners = {}
    self.__index = self
    return setmetatable(o, self)
end


function EventDispatcher:addEventListener(eventName, listener, isOnce)

    local a = self._listeners

    if a==nil then return false,0 end

    a[#a+1] = { evt=eventName, obj=listener, isOnce=isOnce }

    return true
end


function EventDispatcher:dispatchEvent(event, ...)
    if event==nil then return false end

    if type(event)=="table" then
        if event.name==nil or type(event.name)~="string" or #event.name==0 then return false end
    elseif type(event)=="string" then
        if #event==0 then return false end
        event = { name=event }
    end

    local a = self._listeners
    if a==nil then return false end

    local dispatched = false
    for _,o in next,a do
        if o~=nil and o.obj~=nil and o.evt==event.name then
            event.target = o.obj
            event.source = self

            if type(o.obj)=="function" then
                o.obj(event, ...)
                if o.isOnce then self:removeEventListener(event.name, o.obj, true) end
                dispatched = true
            elseif type(o.obj)=="table" then
                local f = o.obj[event.name]
                if f~= nil then
                    f(event, ...)
                    if o.isOnce then self:removeEventListener(event.name, o.obj, true) end
                    dispatched = true
                end
            end
        end
    end

    return dispatched
end

setmetatable(EventDispatcher, { __call = function(_, ...) return EventDispatcher:init(...) end })

Event = EventDispatcher()
