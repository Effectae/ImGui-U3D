import "android.net.Uri"
import "android.provider.Settings"
import "android.content.Intent"
import "android.os.Build"
pcall(function()
  local powerManager = this.getSystemService(this.POWER_SERVICE)
  if Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
    if !powerManager.isIgnoringBatteryOptimizations(activity.getPackageName())
      iosAlertDialog(this)
      .setOnClick(function(d,l,v)
        local intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
        intent.setData(Uri.parse("package:"..activity.getPackageName()))
        this.startActivity(intent)
      end)
      .setTitle("温馨提示")
      .setMessage("检测到您没有开启省电无限制，请点击跳转授权界面！")
      .setButton("授权")
      .setCancelable(false)
      .show()
    end
  end
end)

pcall(function()
  if not Settings.canDrawOverlays(this)
    if Build.VERSION.SDK_INT >= 23
      iosAlertDialog(this)
      .setOnClick(function(d,l,v)
        local intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
        intent.setData(Uri.parse("package:" .. activity.getPackageName()));
        activity.startActivityForResult(intent, 100);
        os.exit()
      end)
      .setTitle("温馨提示")
      .setMessage("检测到您没有给予悬浮窗权限，请点击跳转授权界面！")
      .setButton("授权")
      .setCancelable(false)
      .show()
     else
      iosAlertDialog(this)
      .setOnClick(function(d,l,v)
        local intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        intent.setData(Uri.parse("package:" .. activity.getPackageName()));
        activity.startActivityForResult(intent, 100);
        os.exit()
      end)
      .setTitle("温馨提示")
      .setMessage("检测到您没有给予悬浮窗权限，请前往应用详情开启权限！")
      .setButton("跳转")
      .setCancelable(false)
      .show()
    end
  end
end)