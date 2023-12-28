require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import 'android.graphics.*'
import "android.graphics.drawable.*"
import "android.text.*"
import "android.text.style.*"
import "android.content.*"
import "android.view.animation.*"
import "android.provider.*"

--默认值
骨骼模式=false--如果您的二进制没有骨骼数据，请关闭该选项
精简模式=false--实在不会用可以打开精简模式
绘制开关=false
绘制信息=true
绘制背敌=true
绘制射线=true
绘制方框=true
绘制准星=true
绘制骨骼=true
击伤开关=true--如果满屏幕飞数字，可以关掉击伤开关

--draw已拆分成文件夹，init为入口文件，其余文件皆为绘制主题
--simple 精简 skeleton 骨骼 default 默认

xpcall(function()
  this.theme=android.R.style.Theme_Material_Light_DarkActionBar
  this.ActionBar.backgroundDrawable=ColorDrawable(0xff009688)
  local sp = SpannableString(this.title)
  sp.setSpan(ForegroundColorSpan(0xffffffff),0,#sp,Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  this.ActionBar.setTitle(sp)
  if Build.VERSION.SDK_INT >= 21 then
    this.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(0xff009688);
  end--设置标题栏

  ROOT=os.execute("su")
  if (!ROOT)and tonumber(Build.VERSION.SDK) >=31
    import 'auto'
    if (!auto.isEnable()) or !auto.service
      Toast.makeText(activity, "无障碍服务异常！",Toast.LENGTH_LONG).show()
      activity.newActivity("main",{true})
      activity.finish()
      error("无障碍服务异常！")
    end
  end
  import "yumi"--导入模板
  import "config"--导入菜单配置

  stdin.ttf="res/1.ttf"--设置日志字体
  draw.ttf="res/1.ttf"--设置绘制字体
  dialog2.ttf="res/1.ttf"--设置列表对话框字体
  dialog3.ttf="res/1.ttf"--设置提示对话框字体


  m振动=振动(15)

  function 菜单()--悬浮球点击事件
    m振动()
    清空颜色缓存()--清除颜色缓存
    mDraw.刷新()--刷新画布
    file=io.open("/sdcard/b.log",'r')--刷新文件指针
    collectgarbage("collect")--垃圾回收
    Config("config.menu",1)--调用菜单
    --菜单结构在config/menu.aly
    --菜单功能在config/code.lua
    --第二参数 样式，1为ios样式 2为原生样式
    --具体教程，请前往 https://cloud-note.cn/noteshare/4704e23f3f1cc880cce9fe54cc035fb9
  end

  send("开始运行[main.lua]","I")--输出I类型的日志
  send("启动View渲染方案","I")
  send("正在检测更新...","I")
  send("正在获取公告...","I")
  send([[

本辅助使用YUMI模板开发
辅助名称: YUMI
辅助作者: 狸猫
辅助版本: 1.52
游戏名称: PUBG MOBILE
游戏版本: 国际服]],"D")

  local url="https://cloud-note.cn/noteshare/5c74d13f8932bc37946a6f0fec8d9080"--设置跳转链接
  local view=msg("点我跳转",0xff009688)
  view.paint.setFakeBoldText(true)
  view.onClick=lambda:m振动(),import "android.content.Intent",import "android.net.Uri",activity.startActivity(Intent("android.intent.action.VIEW",Uri.parse(url)))
  send(msg("官方文档: "),view)

  send(msg("请开启自启动和省电无限制，否则可能会掉后台，",0xFFFF8400))
  send(msg("绘制卡死不动，可以查看左上角的FPS是否波动，如有波动，检查你的CPP是否异常，否则请前往draw.lua文件开启调试模式，分析错误原因。",0xff00af00))
  send(msg("如果红点无法与游戏准星对准，请关闭异形屏适配。",0xFF007FFF))
  send(msg("悬浮录屏伪装仅支持部分机型，可在绘制配置中开启。",0xFF8000FF))
  send(msg("如果严重掉帧，可前往绘制配置开启极致流畅模式。",0xffff0000))

  send("正在申请权限...","I")
  import 'permiss'

  if ROOT
    send("当前为Root环境","D",0xffff0000)
   else
    send("当前为框架环境","D",0xffff0000)
  end

  send("正在启动悬浮窗...","I")

  xpcall(function()
    悬浮管理.addView(悬浮球,悬浮球容器)--显示悬浮球
    send("悬浮窗开启成功！","D",0xffff0000)
  end,function()
    send("悬浮窗启动失败！","E")
    local view=msg("弹出菜单",0xff009688)
    view.paint.setFakeBoldText(true)
    view.onClick=菜单
    send(msg("备用入口: "),view)

    iosAlertDialog(this)
    .setOnClick(function(d,l,v)
    end)
    .setTitle("温馨提示")
    .setMessage("悬浮窗启动失败！请使用备用入口打开菜单。")
    .setButton("我知道了")
    .setCancelable(false)
    .show()
  end)

  luajava.bindClass "android.media.MediaPlayer"().reset().setDataSource(this.luaDir.."/res/1.mp3").prepare().setOnPreparedListener(luajava.bindClass "android.media.MediaPlayer".OnPreparedListener{ onPrepared=function(mediaPlayer) mediaPlayer.start() end})
  --播放启动音效

end,function(e)
  send(e,"E")
end)


--©2021 狸猫版权所有
