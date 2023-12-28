import "android.provider.Settings"
import "android.content.*"
import "android.net.*"
GlobalDialog=function(a,b)------------------------------------------------------你好像发现了什么(´◑д◐｀)
  if a==activity
    a=nil
  end
  return setmetatable({
    obj=(a or AlertDialog.Builder)(b or this.context),
    button_click={},
    show_event={
      function(self,obj)
        pcall(function()
          local v=obj.getButton(-1)
          local root=v.parent.parent.parent
          local title=root.getChildAt(0).getChildAt(0).getChildAt(1)
          root.post(function()
            pcall(function()
              title.typeface=rawget(self,ttf)
            end)
            pcall(function()
              local msg=root.getChildAt(1).getChildAt(0).getChildAt(0).getChildAt(1)
              msg.textColor=0xff7f7f7f
              msg.typeface=rawget(self,ttf)
            end)
            pcall(function()
              if root.getHeight()>activity.height*0.8
                linearParams = root.getLayoutParams()
                linearParams.height =activity.height*0.8
                root.setLayoutParams(linearParams)
              end
            end)
          end)
          for k0,v0 pairs(self.button_click)
            local view=obj.getButton(-k0)
            if rawget(self,ttf)
              view.typeface=rawget(self,ttf)
            end
            view.onClick=function(v)
              if v0(v)~=false
                obj.hide()
              end
            end
          end
        end)
      end
    },
    fun={
      setTypeface=function(self,a)
        if type(a)=="string"
          import "java.io.*"
          local file,err=io.open(activity.getLuaDir(tostring(a)))
          if not err then
            import "android.graphics.*"
            import "java.io.File"
            self.ttf= Typeface.createFromFile(File(activity.getLuaDir(tostring(a))))
          end
         else
          self.ttf=a
        end
      end,
      setButton=function(self,a,b)
        self.setPositiveButton(tostring(a))
        self.button_click[1]=b
      end,
      setButton1=function(self,a,b)
        self.setPositiveButton(tostring(a))
        self.button_click[1]=b
      end,
      setButton2=function(self,a,b)
        self.setNegativeButton(tostring(a))
        self.button_click[2]=b
      end,
      setButton3=function(self,a,b)
        self.setNeutralButton(tostring(a))
        self.button_click[3]=b
      end,
    },
  },{
    __index=function(self,key)
      if rawget(rawget(self,"fun"),key)
        return lambda ...:self,rawget(rawget(self,"fun"),key)(self,...)
       elseif rawget(self,key)
        return rawget(self,key)
       elseif key=="show"
        local c=self.obj.create()
        self.obj=c
        local wmParam=c.window
        if tonumber(Build.VERSION.SDK) >= 26 then
          wmParam.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
         else
          wmParam.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
        end
        if 录屏伪装
          初始化(wmParam,nil,1).隐藏()
        end
        return function()
          if not c.getButton(-1)
            c.show()
            for k,v pairs(self.show_event)
              v(self,c,wmParam)
            end
            return c
          end
        end
       elseif key:find("^set")
        return function(...)
          local d={...}
          local e
          xpcall(function()
            e=self.obj[key](table.unpack(d))
          end,function()
            xpcall(function()
              e=self.obj[key](table.unpack(d),nil)
            end,function(a)
              error(a)
            end)
          end)
          return self,e
        end
       else
        return self.obj[key]
      end
    end
  })
end


