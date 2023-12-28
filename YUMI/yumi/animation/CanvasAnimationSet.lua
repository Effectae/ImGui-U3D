module("CanvasAnimationSet",package.seeall)
local socket=require "socket"

local obj={}

function obj:append(...)
  local t={...}
  local tab={}
  self.list[#self.list+1]=tab
  for i=1,#t,2
    tab[t[i]]=t[i+1]
  end
end

function obj:set(k,...)
  local t={...}
  local tab={}
  self.list[k]=tab
  for i=1,#t,2
    tab[t[i]]=t[i+1]
  end
end

function obj:get(k)
  return self.list[k]
end

function obj:forEach(fun,done)
  local time=socket.gettime()*1000
  for k,v pairs(self.list)
    local t={}
    local num=0
    for k1,v1 pairs(v)
      v1:refresh(time)
      if v1:isEnd()
        t[k1]=v1:getValue(1)
       else
        num=num+1
        t[k1]=v1:getValue()
      end
    end
    if num==0
      local _
      if done
        _=done(v)
      end
      if !_
        self.list[k]=nil
      end
     else
      fun(t,v)
    end
  end
end

return function()
  local o=table.clone(obj)
  o.list={}
  return o
end