local function 方向()
  local a=activity.getWindowManager().getDefaultDisplay().getSize(Point());
  return a.rotation
end

dialog2={
  __newindex=function(self,key,value)
    rawset(self,key,Typeface.createFromFile(File(activity.getLuaDir(tostring(value)))))
  end
}
setmetatable(dialog2,dialog2)



function iosItemDialog(context)
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
        layout_width="match_parent",
        orientation="vertical",
        padding="8dp",
        paddingBottom="18dp";
        visibility="gone";
        {
          CardView;
          radius="5dp";
          layout_width="match_parent",
          backgroundColor=0xffe6e6e6;
          {
            LinearLayout,
            layout_width="match_parent",
            layout_height="wrap_content",
            orientation="vertical",
            {
              TextView,
              id="txt_title",
              layout_width="match_parent",
              layout_height="45dp",
              gravity="center",
              paddingTop="10dp",
              paddingBottom="10dp",
              paddingLeft="15dp",
              paddingRight="15dp",
              textColor="#8F8F8F",
              textSize="13sp",
              visibility="gone";
              Typeface=dialog2.ttf;
            },
            {
              ScrollView,
              id="sLayout_content",
              layout_width="match_parent",
              layout_height="wrap_content",
              OverScrollMode=2;
              {
                LinearLayout,
                id="lLayout_content",
                layout_width="match_parent",
                layout_height="wrap_content",
                orientation="vertical",
              },
            },
          },
        },
        {
          CardView;
          radius="5dp";
          layout_marginTop="8dp",
          layout_width="match_parent",
          backgroundColor=0xffe6e6e6;
          {
            TextView,
            id="txt_cancel",
            layout_width="match_parent",
            layout_height="45dp",
            gravity="center",
            text="取消",
            textColor="#037BFF",
            textSize="18sp",
            Typeface=dialog2.ttf;
            style="?android:attr/buttonBarButtonStyle";
          },
        };
      },ids)

      obj=LuaDialog(context)

      self={
        setCancelable=function(v)
          self.lock=v
          return self
        end,
        setItems=function(t)
          local tab={}
          for i=1,#t
            ids.lLayout_content.addView(loadlayout{
              View;
              layout_height="0.5dp",
              layout_width="match_parent",
              backgroundColor="#ffc6c6c6";
            })
            local v,color
            if t[i]:find"^Red_"
              color=0xffFD4A2E
             else
              color=0xff037BFF
            end
            v=loadlayout{
              TextView;
              text=t[i]:gsub("^%w-_","");
              textSize="18sp";
              gravity="center";
              layout_height="45dp",
              layout_width="match_parent",
              textColor=color;
              style="?android:attr/buttonBarButtonStyle";
              Typeface=dialog2.ttf;
              onClick=function(v)
                e,c=pcall(fun,obj,v,i)
                if c~=false
                  self.dismiss()
                end
                if not e
                  error(c)
                end
              end
            }
            tab[i]=v
            ids.lLayout_content.addView(v)
          end
          ids.lLayout_content.tag=tab
          return self
        end,
        setTitle=function(str)
          ids.txt_title.setText(str).setVisibility(0)
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
          window.gravity = Gravity.BOTTOM | Gravity.CENTER
          ids.txt_cancel.onClick=lambda:self.dismiss()
          ids.txt_cancel.getPaint().setFakeBoldText(true)
          obj.setView(view)
          if 录屏伪装
            初始化(window,nil,1).隐藏()
          end
          local _=obj.show()
          view.post(function()
            view.setVisibility(0)

            local dv=obj.window.DecorView
            local _view=dv.class.getDeclaredField("mContentRoot").setAccessible(true).get(dv)

            view.getViewTreeObserver().addOnGlobalLayoutListener(ViewTreeObserver.OnGlobalLayoutListener{
              onGlobalLayout=function()
                local h
                if this.getHeight()>this.getWidth() and 方向()~=0
                  h=this.getWidth()
                 elseif this.getHeight()<this.getWidth() and 方向()==0
                  h=this.getHeight()
                  local params = _view.getLayoutParams();
                  params.width = this.height*0.95;
                  _view.setLayoutParams(params);
                 else
                  h=this.getHeight()
                end
                if ids.sLayout_content.height>h/2
                  local params = ids.sLayout_content.getLayoutParams();
                  params.height = h/2;
                  ids.sLayout_content.setLayoutParams(params);
                end
              end
            });
          end)
          if self.lock!=nil
            _.setCancelable(self.lock)
          end
          return _
        end,
        dismiss=function()
          local y=view.getY()
          obj.dismiss()
          view.y=y
          view.setVisibility(8)
          return self
        end,
      }
      return self
    end}

end


