return function(view,画布,画笔,self,fps,data)

  setColor('FPS画笔',0xffffffff)--设置画笔颜色

  画布.drawText("FPS "..fps(),100,120,FPS画笔)--绘制FPS

  file:seek('set')--移动文件指针
  for str file:lines()--按行读取b.log

    string.split(str,",")--将分割后的字符串存入data
    local x,y,w,hp,ai=--x y 宽度 血量 人机判断
    tonumber(data[1]),tonumber(data[2]), tonumber(data[3]), tonumber(data[6]), tonumber(data[7])

    if x and y and w and hp and ai--防止数据出错

      if w>0--过滤掉背后的敌人
        x=x+(w/2)--身位矫正 把坐标向右移动半个身体的位置

        if w<10--最小半径约束
          w=10
        end

        --瞄准判断
        if y>height_2-w and y<height_2+w and x>width_2-w and x<width_2+w
          画布.drawCircle(x,y,w,圈圈画笔3)--瞄准内圈发光
         else
          if hp>70--切换内圈颜色
            setColor('圈圈画笔2',0xef00ff00)
           elseif hp>40
            setColor('圈圈画笔2',0xEFfF8000)
           elseif hp>0
            setColor('圈圈画笔2',0xefef0000)
           else
            setColor('圈圈画笔2',0xEF7000eF)
          end
          画布.drawCircle(x,y,w,圈圈画笔2)--绘制内圈
        end

        if ai==0--人机
          setColor('圈圈画笔1',0xfF0000ff)
         else--真人
          setColor('圈圈画笔1',0xfFffffFF)
        end

        if w<20--最小半径约束
          画布.drawCircle(x,y,50,圈圈画笔1)
         else
          画布.drawCircle(x,y,w*2.5,圈圈画笔1)--绘制外圈
        end


      end
    end
    --table.clear(data)--清空data，如要开启调试模式，建议取消注释
  end

end