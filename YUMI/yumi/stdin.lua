module("stdin",package.seeall)

scroll=loadlayout{
  ScrollView;
  layout_width="fill";
  layout_height="fill";
  OverScrollMode=2;
}
容器=loadlayout{
  LinearLayout;
  orientation="vertical";
  layout_height="match_parent";
  layout_width="match_parent";
  padding="2dp";
  paddingBottom="10%h";
}
scroll.addView(容器)
xpcall(function()
  fragment=LuaFragment()
  fragment.layout=scroll
end,function()
  fragment=LuaFragment(scroll)
end)
activity.fragment=fragment
function _G.toEnd()
  scroll.post(function()
    scroll.fullScroll(ScrollView.FOCUS_DOWN)
  end)
end
function _G.log(a,b)
  if logmode==1
    return os.date("%Y-%m-%d %H:%M:%S.")..tostring(Date().time):sub(-3,-1).."/"..a..": "..b
   elseif logmode==2
    return os.date("%Y-%m-%d %H:%M:%S/"..a..": ")..b
   elseif logmode==3
    return os.date("%H:%M:%S.")..tostring(Date().time):sub(-3,-1).."/"..a..": "..b
  end
end
logmode=3
function _G.send(...)
  local tab={...}
  if #tab==0
    tab[1]=msg""
  end
  if type(tab[2])=="string" and tab[3]
    tab={msg(log(tab[2],tab[1]),tab[3] or 0xff000000)}
   elseif tab[2]=="I"
    tab={msg(log(tab[2],tab[1]),0xff7f7f7f)}
   elseif tab[2]=="D"
    tab={msg(log(tab[2],tab[1]))}
   elseif tab[2]=="E"
    tab={msg(log(tab[2],tab[1]),0xffff0000)}
  end
  local view=loadlayout{
    LinearLayout;
    layout_width="match_parent";
  }
  for i=1,#tab
    view.addView(tab[i])
  end
  容器.addView(view)
  toEnd()
  return view
end
function _G.setCursorDrawableColor( editText, color)
  pcall(function()
    import "android.graphics.*"
    import "android.graphics.drawable.Drawable"
    local cursorDrawableResField = TextView.getDeclaredField("mCursorDrawableRes");
    cursorDrawableResField.setAccessible(true);
    local cursorDrawableRes = cursorDrawableResField.getInt(editText);
    local editorField = TextView.getDeclaredField("mEditor");
    editorField.setAccessible(true);
    local editor = editorField.get(editText);
    local clazz = editor.getClass();
    local res = editText.getContext().getResources();
    if (Build.VERSION.SDK_INT >= 28)
      local drawableForCursorField = clazz.getDeclaredField("mDrawableForCursor");
      drawableForCursorField.setAccessible(true);
      local drawable = res.getDrawable(cursorDrawableRes,editText.getContext().getTheme());
      drawable.setColorFilter(PorterDuffColorFilter(color, PorterDuff.Mode.SRC_IN));
      drawableForCursorField.set(editor, drawable);
     else
      local cursorDrawableField = clazz.getDeclaredField("mCursorDrawable");
      cursorDrawableField.setAccessible(true);
      local drawables = Drawable[2];
      drawables[0] = res.getDrawable(cursorDrawableRes);
      drawables[1] = res.getDrawable(cursorDrawableRes);
      drawables[0].setColorFilter(color, PorterDuff.Mode.SRC_IN);
      drawables[1].setColorFilter(color, PorterDuff.Mode.SRC_IN);
      cursorDrawableField.set(editor, drawables);
    end
  end)
end
function _G.usettf(path)
  if path and hasttf~=path
    import "java.io.*"
    local file,err=io.open(activity.getLuaDir(tostring(path)))
    if not err then
      import "android.graphics.*"
      import "java.io.File"
      hasttf=Typeface.createFromFile(File(activity.getLuaDir(tostring(path))))
      return hasttf
    end
   elseif hasttf==path
    return hasttf
  end
end
function _G.msg(str,color)
  if str
    return loadlayout{
      TextView;
      text=tostring(str);
      textColor=(color or color)or 0xff000000;
      textSize=size or "15dp";
      typeface=usettf(ttf);
    }
  end
end

function _G.input(color,inputcolor,r)
  local a= loadlayout{
    EditText;
    singleLine=r or true;
    layout_width="match_parent";
    textColor=(color or color)or 0xff000000;
    textSize=size or "15dp";
    backgroundColor=0;
    padding=0;
    typeface=usettf(ttf);
  }
  setCursorDrawableColor(a,inputcolor or color or color or 0xff000000)
  return a
end
function _G.input_event(a,b)
  a.setOnKeyListener(View.OnKeyListener{
    onKey=function(v,keyCode,event)
      if (keyCode == KeyEvent.KEYCODE_ENTER)
        if event.getAction() == KeyEvent.ACTION_DOWN
          if b(a,v.text)~=false
            v.Focusable=false
          end
        end
        return true;
      end
      return false
    end
  });
  return a
end
function _G.clear()
  容器.removeAllViews()
  return true
end
function _G.remove(a)
  if type(a)=="number"
    容器.removeViewAt(a-1)
   else
    容器.removeView(a)
  end
  return true
end
function _G.move(a,b)
  remove(a)
  容器.addView(a,b-1)
  return true
end


_G.stdin=_M
return _M