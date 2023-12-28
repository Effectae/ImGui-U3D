(function()
  require "import"
  compile 'auto/classes.dex'
  import "com.androlua.LuaAccessibilityService"
  import "muling.utils.api.accessibility.AccessibilityBridge"
  local mAccessibilityBridge=AccessibilityBridge(activity,LuaAccessibilityService)

  import "muling.utils.api.accessibility.view.UiSelector"
  _ENV.selector=function()
    return UiSelector(mAccessibilityBridge)
  end

  local ms=UiSelector.getDeclaredMethods()
  for i=0,#ms-1 do
    local m=ms[i]
    local name=m.getName()
    if name=="findImpl" then continue end
    _ENV[name]=function(...)
      return selector()[name](...)
    end
  end

  import "muling.utils.api.accessibility.global.GlobalAction"
  local mGlobalAction=GlobalAction(mAccessibilityBridge)
  local ms=GlobalAction.getDeclaredMethods()
  for i=0,#ms-1 do
    local m=ms[i]
    local name=m.getName()
    if name=="performGlobalAction" then continue end
    _ENV[name]=mGlobalAction[name]
  end

  import "muling.utils.api.accessibility.gesture.GesturePerformer"
  import "java.lang.reflect.Modifier"
  local mGesturePerformer=GesturePerformer(mAccessibilityBridge)
  local ms=GesturePerformer.getDeclaredMethods()
  for i=0,#ms-1 do
    local m=ms[i]
    local name=m.getName()
    if not Modifier.isPublic(m.getModifiers()) then continue end
    _ENV[name]=mGesturePerformer[name]
  end

  local auto={}
  auto.isEnable=function()
    return mAccessibilityBridge.isAccessibilityServiceEnable()
  end
  auto.goToAccessibilitySetting=function()
    mAccessibilityBridge.goToAccessibilitySetting();
  end


  setmetatable(auto,{
    __index=function(self,key)
      if key=="service" then
        return mAccessibilityBridge.getService()
      end
      return nil
    end
  })

  _ENV.auto=auto

  import "muling.utils.api.app.App"
  local app=App(activity)
  _ENV.launch=app.launchPackage
  _ENV.launchApp=app.launchApp

end)()