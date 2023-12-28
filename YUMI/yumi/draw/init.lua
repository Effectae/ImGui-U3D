file=io.open("/sdcard/b.log",'r')--获取文件对象

local 精简主题=require 'yumi.draw.simple'--导入绘制主题
local 默认主题=require 'yumi.draw.default'--导入绘制主题
local 骨骼主题=require 'yumi.draw.skeleton'--导入绘制主题

mDraw=LimoDrawable{--创建LuaDrawable对象
  view=window,--设置图层控件
  data=Split_Table,--绑定数组
  调试模式=false,--分析错误日志并给出部分异常的解决方案 (发布前请关闭，否则将会影响帧率)
  onDraw=function(view,画布,画笔,self,fps,data)--控件对象 画布 画笔 LuaDrawable对象 获取FPS 内部数据表
    if 绘制开关--控制是否绘制图形

      if 精简模式
        精简主题(view,画布,画笔,self,fps,data)
       elseif 骨骼模式
        骨骼主题(view,画布,画笔,self,fps,data)
       else
        默认主题(view,画布,画笔,self,fps,data)
      end

    end

    if 绘制准星
      画布.drawCircle(width_2,height_2,4,准星画笔)--绘制红色准星
    end
  end
}






