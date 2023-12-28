require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.text.*"
import "android.text.style.*"
import "android.graphics.drawable.*"


if tonumber(Build.VERSION.SDK) >=31
  if os.execute('su')
    import 'su'
    su('settings put global block_untrusted_touches 0')
    import 'index'
    return
  end

  this.theme=android.R.style.Theme_Material_Light_DarkActionBar
  this.ActionBar.backgroundDrawable=ColorDrawable(0xff009688)
  local sp = SpannableString(this.title)
  sp.setSpan(ForegroundColorSpan(0xffffffff),0,#sp,Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  this.ActionBar.setTitle(sp)
  if Build.VERSION.SDK_INT >= 21 then
    this.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(0xff009688);
  end--设置标题栏
  activity.setContentView('welcome')
  txt.text='正在检查无障碍服务...'
  import 'auto'
  txt.text='正在开启无障碍服务...'
  if (!auto.isEnable()) or !auto.service
    task(200,function()
      Toast.makeText(activity, "请开启无障碍服务！",Toast.LENGTH_LONG).show()
      auto.goToAccessibilitySetting()
      function onStop()
        function onStart()
          txt.text='正在重新申请权限...'
          task(100,function()
            activity.newActivity("main",{true})
            activity.finish()
          end)
        end
      end
    end)
   else
    txt.text='正在跳转软件主页...'
    task(100,function()
      activity.newActivity("index")
      activity.finish()
    end)
  end
 else
  import 'index'
end