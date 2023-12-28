local function 方向()
  $a=activity.getWindowManager().getDefaultDisplay().getSize(Point());
  return a.rotation
end

dialog3={
  __newindex=function(self,key,value)
    rawset(self,key,Typeface.createFromFile(File(activity.getLuaDir(tostring(value)))))
  end
}
setmetatable(dialog3,dialog3)

function iosAlertDialog(context)
  import "android.graphics.*"
  import "android.animation.*"
  import "android.view.animation.*"
  import "android.provider.*"
  return {setOnClick=function(fun)
      local obj,view,self
      local ids={}
      view=loadlayout(
      {
        LinearLayout,
        padding="8dp",
        {
          CardView;
          radius="8dp";
          layout_width="match_parent",
          backgroundColor=0xffe6e6e6;
          {
            LinearLayout,
            id="lLayout_bg",
            layout_width="match_parent",
            layout_height="wrap_content",
            orientation="vertical",
            {
              TextView,
              id="txt_title",
              layout_width="match_parent",
              layout_height="wrap_content",
              layout_marginLeft="15dp",
              layout_marginRight="15dp",
              layout_marginTop="15dp",
              gravity="center",
              textColor="#000000",
              textSize="18sp",
              Typeface=dialog3.ttf;
            },
            {
              TextView,
              id="txt_msg",
              layout_width="match_parent",
              layout_height="wrap_content",
              layout_marginLeft="20dp",
              layout_marginRight="20dp",
              layout_marginTop="10dp",
              layout_marginBottom="5dp";
              gravity="center",
              textColor="#000000",
              textSize="16sp",
              Typeface=dialog3.ttf;
            },
            {
              View,
              layout_width="match_parent",
              layout_height="0.5dp",
              layout_marginTop="10dp",
              background="#c6c6c6"
            },
            {
              LinearLayout,
              layout_width="match_parent",
              layout_height="wrap_content",
              orientation="horizontal",
              {
                TextView,
                id="btn_neg",
                layout_width="wrap_content",
                layout_height="43dp",
                layout_weight="1",
                gravity="center",
                textColor="#037BFF",
                textSize="16sp";
                style="?android:attr/buttonBarButtonStyle";
                visibility=8;
                Typeface=dialog3.ttf;
                onClick=function(v)
                  local a,b=pcall(fun,obj,v,2)
                  if b~=false
                    obj.dismiss()
                  end
                  if not a
                    error(b)
                  end
                end
              },
              {
                View,
                id="img_line",
                layout_width="0.5dp",
                layout_height="43dp",
                background="#c6c6c6";
                visibility=8;
              },
              {
                TextView,
                id="btn_pos",
                layout_width="wrap_content",
                layout_height="43dp",
                layout_weight="1",
                gravity="center",
                textColor="#037BFF",
                textSize="16sp",
                Typeface=dialog3.ttf;
                style="?android:attr/buttonBarButtonStyle";
                onClick=function(v)
                  local a,b=pcall(fun,obj,v,1)
                  if b~=false
                    obj.dismiss()
                  end
                  if not a
                    error(b)
                  end
                end
              },
            },
          };
        };
      },ids)
      obj=LuaDialog(context)

      self={
        setCancelable=function(v)
          self.lock=v
          return self
        end,
        setButton=function(str)
          if type(str)=="string"
            ids.btn_pos.setText(str)
          end
          return self
        end,
        setButton2=function(str)
          if type(str)=="string"
            ids.btn_neg.setText(str).visibility=0
            ids.img_line.visibility=0
          end
          return self
        end,
        setTitle=function(...)
          ids.txt_title.setText(...)
          return self
        end,
        setMessage=function(...)
          ids.txt_msg.setText(...)
          return self
        end,
        show=function()
          local window=obj.getWindow()
          window.setBackgroundDrawable(LuaDrawable(lambda:nil))
          if not(Build.VERSION.SDK_INT >= 23 and (not Settings.canDrawOverlays(this)))
            if tonumber(Build.VERSION.SDK) >= 26 then
              window.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
             else
              window.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
            end
          end
          obj.setView(view)
          ids.txt_title.getPaint().setFakeBoldText(true)
          ids.btn_pos.getPaint().setFakeBoldText(true)
          local dv=obj.window.DecorView
          local _view=dv.class.getDeclaredField("mContentRoot").setAccessible(true).get(dv)
          if 录屏伪装
            初始化(window,nil,1).隐藏()
          end
          local _=obj.show()
          _view
          .getChildAt(0)
          .getChildAt(0)
          .removeView(_view
          .getChildAt(0)
          .getChildAt(0)
          .getChildAt(0))
          _view
          .getChildAt(0)
          .getChildAt(0)
          .removeView(_view
          .getChildAt(0)
          .getChildAt(0)
          .getChildAt(0))
          _view
          .getChildAt(0)
          .getChildAt(0)
          .removeView(_view
          .getChildAt(0)
          .getChildAt(0)
          .getChildAt(1))

          _view.getViewTreeObserver().addOnGlobalLayoutListener(ViewTreeObserver.OnGlobalLayoutListener{
            onGlobalLayout=function()
              if this.getHeight()<this.getWidth() and 方向()==0
                local params = _view.getLayoutParams();
                params.width = this.height*0.95;
                _view.setLayoutParams(params);
              end
            end
          });

          if self.lock!=nil
            _.setCancelable(self.lock)
          end

          return _
        end,
      }
      return self
    end}

end