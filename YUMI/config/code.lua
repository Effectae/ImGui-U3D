module("code",package.seeall)


击伤特效={
  开启=function()
    _G.击伤开关=true
  end,
  关闭=function()
    _G.击伤开关=false
  end
}

元素精简={

  绘制信息={
    开启=function()
      _G.绘制信息=true
    end,
    关闭=function()
      _G.绘制信息=false
    end
  },

  绘制背敌={
    开启=function()
      _G.绘制背敌=true
    end,
    关闭=function()
      _G.绘制背敌=false
    end
  },

  绘制射线={
    开启=function()
      _G.绘制射线=true
    end,
    关闭=function()
      _G.绘制射线=false
    end
  },

  绘制方框={
    开启=function()
      _G.绘制方框=true
    end,
    关闭=function()
      _G.绘制方框=false
    end
  },

  绘制骨骼={
    开启=function()
      _G.绘制骨骼=true
    end,
    关闭=function()
      _G.绘制骨骼=false
    end
  },

  绘制准星={
    开启=function()
      _G.绘制准星=true
    end,
    关闭=function()
      _G.绘制准星=false
    end
  }

}

极致流畅={
  开启=function()
    _G.精简模式=true
  end,
  关闭=function()
    _G.精简模式=false
  end
}

异形屏适配={
  开启=function()
    矫正=nil
    画布容器.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
    | WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
    | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
    | WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED--硬件加速
    | WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN
    | WindowManager.LayoutParams.FLAG_FULLSCREEN
    | WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
    _G.width=屏幕高()
    _G.height=屏幕宽()
  end,
  关闭=function()
    画布容器.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
    | WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
    | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
    | WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED--硬件加速
    if this.width>this.height
      _G.width=this.width
     else
      _G.width=this.height
    end
    _G.height=屏幕宽()
  end
}



数据分割方案={
  方案一=function()
    string.split=split1
  end,
  方案二=function()
    string.split=split2
  end,
  方案三=function()
    string.split=split3
  end
}

悬浮录屏伪装={
  开启=function()
    _G.录屏伪装=true
    悬浮球伪装.隐藏()
    画布伪装.隐藏()
  end,
  关闭=function()
    _G.录屏伪装=false
    悬浮球伪装.显示()
    画布伪装.显示()
  end
}

绘制功能={
  开启=function()
    xpcall(function()
      --这只是示例，分辨率文件需要与二进制匹配，否则将会偏框
      io.open("/sdcard/x","w"):write(屏幕高()):close()
      io.open("/sdcard/y","w"):write(屏幕宽()):close()
      io.open("/sdcard/b.log","w"):write(""):close()
      --这只是示例，杀进程文件需要与二进制匹配，否则将会闪框
      io.open("/sdcard/stop","w"):write(""):close()
      os.remove"/sdcard/stop"
      MD提示("开启成功", "#0081FF", "#ffffffff", "0", "20")
      _G.绘制开关=true
      执行("res/draw")
      send("开启成功","D",0xffff0000)
    end,function(a)
      send(a,"E")
    end)
  end,
  关闭=function()
    _G.绘制开关=false
    MD提示("关闭成功","#0081FF","#ffffff","0","20")
    io.open("/sdcard/stop","w"):write(""):close()
    send("关闭成功","D",0xffff0000)
  end
}



--©2021 狸猫版权所有
return _M