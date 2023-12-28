function 初始化(l,v,dia)
  local a,t,w
  if not dia
    a,t,w=l.flags,l.title,this.getSystemService(Context.WINDOW_SERVICE)
   else
    w=this.getSystemService(Context.WINDOW_SERVICE)
  end
  return {
    隐藏=function()
      if v
        w.removeView(v)
      end
      if not dia
        l.flags=a|WindowManager.LayoutParams().FLAG_DITHER | 1048576 | 262696 | 131072 | 4136
       else
        l.addFlags(WindowManager.LayoutParams().FLAG_DITHER | 1048576 | 262696 | 131072 | 4136)
        l.setDimAmount(0)
      end
      if RomUtil.isMiui()
        l.title="com.miui.screenrecorder"
       elseif RomUtil.isEmui()
        l.title="ScreenRecoderTimer"
       elseif RomUtil.isVivo()
        l.title="screen_record_menu"
       elseif RomUtil.isOppo()
        l.title="com.coloros.screenrecorder.FloatView"
       elseif RomUtil.isSmartisan()
        l.title=""
       elseif RomUtil.isFlyme()
        pcall(function()
          l.title="SysScreenRecorder"
          local MeizuParamsClass = Class.forName("android.view.MeizuLayoutParams");
          local flagField = MeizuParamsClass.getDeclaredField("flags");
          flagField.setAccessible(true);
          local MeizuParams = MeizuParamsClass.newInstance();
          flagField.setInt(MeizuParams, WindowManager.LayoutParams().FLAG_DITHER | 1048576 | 262696 | 131072 | 4136);
          local mzParamsField = l.getClass().getField("meizuParams");
          mzParamsField.set(l, MeizuParams);
        end)
      end
      if v
        w.addView(v,l)
      end
    end,
    显示=function()
      if v
        w.removeView(v)
      end
      l.flags=a
      l.title=t
      if v
        w.addView(v,l)
      end
    end
  }
end



悬浮管理=activity.getSystemService(Context.WINDOW_SERVICE) --获取窗口管理器



local xfq= {
  LinearLayout;
  layout_width="40dp";
  layout_height="40dp";
  {
    CircleImageView;
    src="res/logo"..math.random(1,2)..".png";
    layout_width="40dp";
    layout_height="40dp";
    onClick="菜单";
    id="图标";
  };
};

悬浮球容器 =WindowManager.LayoutParams() --对象
if tonumber(Build.VERSION.SDK) >= 26 then
  悬浮球容器.type =WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY--安卓8以上悬浮窗打开方式
 else
  悬浮球容器.type =WindowManager.LayoutParams.TYPE_SYSTEM_ALERT--安卓8以下的悬浮窗打开方式
end
import("android.graphics.PixelFormat")
悬浮球容器.format =PixelFormat.RGBA_8888 --设置背景
悬浮球容器.flags=WindowManager.LayoutParams().FLAG_NOT_FOCUSABLE--焦点设置
| WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN
悬浮球容器.gravity = Gravity.LEFT| Gravity.TOP --重力设置
悬浮球容器.x = 500
悬浮球容器.y = 500
悬浮球容器.width = -2
悬浮球容器.height = -2
悬浮球=loadlayout(xfq)
悬浮球伪装=初始化(悬浮球容器,悬浮球)
local firstX,firstY,wmX,wmY
function 图标.OnTouchListener(v,event)
  if event.getAction()==MotionEvent.ACTION_DOWN then
    firstX=event.getRawX()
    firstY=event.getRawY()
    wmX=悬浮球容器.x
    wmY=悬浮球容器.y
   elseif event.getAction()==MotionEvent.ACTION_MOVE then
    悬浮球容器.x=wmX+(event.getRawX()-firstX)
    悬浮球容器.y=wmY+(event.getRawY()-firstY)
    悬浮管理.updateViewLayout(悬浮球,悬浮球容器)
  end
  return false
end



import "android.content.*"
import "android.graphics.*"

function 画布管理()
  local 悬浮管理
  if tonumber(Build.VERSION.SDK) >=31 and !ROOT
    悬浮管理=auto.service.getSystemService(Context.WINDOW_SERVICE)
   else
    悬浮管理=this.getSystemService(Context.WINDOW_SERVICE)
  end
  return 悬浮管理
end

function 画布窗口()
  local 悬浮容器 = WindowManager.LayoutParams()
  if tonumber(Build.VERSION.SDK) >= 31 and !ROOT
    悬浮容器.type = WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY
   elseif tonumber(Build.VERSION.SDK) >= 26
    悬浮容器.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
   else
    悬浮容器.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
  end
  悬浮容器.format = PixelFormat.RGBA_8888
  悬浮容器.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
  | WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
  | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
  | WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN
  | WindowManager.LayoutParams.FLAG_FULLSCREEN
  | WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
  悬浮容器.gravity = Gravity.LEFT | Gravity.TOP
  悬浮容器.width = 3000
  悬浮容器.height = 3000
  return 悬浮容器
end

local 悬浮管理=画布管理()
local 画布容器=画布窗口()

window=View(this)

xpcall(function()
  悬浮管理.addView(window,画布容器)
end,function()
  Toast.makeText(activity, "无障碍服务异常！",Toast.LENGTH_LONG).show()
  auto.service.disableSelf()
  activity.newActivity("main",{true})
  activity.finish()
  error("无障碍服务异常！")
end)

画布伪装=初始化(画布容器,window)

if !ROOT
  function onDestroy()
    if auto.service
      auto.service.disableSelf()
    end
  end
end