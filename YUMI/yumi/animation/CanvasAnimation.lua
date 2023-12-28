module("CanvasAnimation",package.seeall)
local socket=require "socket"

local obj={}


function obj:start(s,e,d,c)
  self.s=s or 0
  self.e=e or 1
  self.t=socket.gettime()*1000
  self.d=d or 800
  self.c=c or 1
  return self
end

function obj:refresh(t)
  if t
    self.time=t
   else
    self.time=socket.gettime()*1000
  end
  return self
end

function obj:getPosition(v)
  if not v
    v=self:getValue()
  end
  local s,e=self.s,self.e
  if e>=s
    return 1-(e-v)/(e-s)
   else
    return (s-v)/(s-e)
  end
end

function obj:getValue(p)
  local v
  if not p
    p=(1-((self.t+self.d)-(self.time))/self.d)
  end
  if self.e>=self.s
    v=self.s+((self.e-self.s)*p)
   else
    v=self.s-((self.s-self.e)*p)
  end
  local value=math.ceil(v/self.c)*self.c
  if self.e>=self.s
    if value>self.e
      return self.e
     elseif value<self.s
      return self.s
    end
   else
    if value<self.e
      return self.e
     elseif value>self.s
      return self.s
    end
  end
  return value
end

function obj:isPlay()
  local v=self:getValue()
  if self.e>=self.s
    return v<self.e and v>self.s
   else
    return v>self.e and v<self.s
  end
end

function obj:isStart()
  local v=self:getValue()
  if self.e>=self.s
    return v>=self.s
   else
    return v<=self.s
  end
end

function obj:isEnd()
  local v=self:getValue()
  if self.e>=self.s
    return v>=self.e
   else
    return v<=self.e
  end
end

function obj:reversal()
  self.s,self.e=self.e,self.s
  return self
end

function obj:reset()
  self.t=socket.gettime()*1000
  return self
end

function obj:sleep(time)
  self.t=self.t+time
  self.time=self.time+time
  return self
end

return function(...)
  local o=table.clone(obj)
  if ...
    o:start(...)
  end
  return o
end