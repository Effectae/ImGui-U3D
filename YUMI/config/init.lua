require "import"

local t={}
function Config(table,style)
  if t[table]
    table=t[table]
   else
    table=import(table)
  end
  local run
  local code=require "config.code"

  run=function(tab)
    local name={}
    for i=2,#tab
      local color=""
      if tab[i].color=="red" and style~=2
        color="Red_"
      end
      name[i-1]=color..tab[i][1]
    end
    if tab.id
      t[tab.id]=tab
    end
    switch(tab.type)
     case "file"
      Config(tab.content,style)
     case "item"
      if style==2
        GlobalDialog(this)--实例化对话框
        .setTitle(tab.title or tab[1])--设置标题
        .setItems(name,{onClick=function(v,id)
            m振动()
            id=id+1
            for i=2,#tab
              if i==id+1
                run(tab[i])
              end
            end
          end})
        .show()
       else
        iosItemDialog(this)
        .setOnClick(function(d,l,v)
          m振动()
          for i=2,#tab
            if i==v+1
              run(tab[i])
            end
          end
        end)
        .setTitle(tab.title or tab[1])
        .setItems(name)
        .show()
      end
     case "alert"
      if style==2
        GlobalDialog(this)
        .setTitle(tab.title or tab[1])
        .setMessage(tab.content)
        .setButton1(tab[2][1],lambda:run(tab[2]))
        .setButton2(tab[3][1],lambda:run(tab[3]))
        .show()
       else
        iosAlertDialog(this)
        .setOnClick(function(d,l,v)
          m振动()
          for i=2,#tab
            if i==v+1
              run(tab[i])
            end
          end
        end)
        .setTitle(tab.title or tab[1])
        .setMessage(tab.content)
        .setButton(tab[2][1])
        .setButton2(tab[3][1])
        .show()
      end
     case "code"
      if tab.content
        if type(tab.content)=="function"
          tab.content()
         else
          local t=code
          tab.content:gsub("[^%.]+",function(w)
            t=t[w]
          end)
          t()
        end
      end
     case "function"
      if type(tab.content)=="string"
        执行(tab.content)
       else
        for k,v ipairs(tab.content)
          执行(v)
        end
      end
      MD提示(tab.title or "开启成功", "#0081FF", "#ffffffff", "0", "20")
    end
  end
  run(table)
end