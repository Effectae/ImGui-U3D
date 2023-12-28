
dm = DisplayMetrics();
activity.getWindowManager().getDefaultDisplay().getRealMetrics(dm);
function 屏幕高()
  local a = dm.widthPixels;
  local b = dm.heightPixels;
  if tonumber(a)>tonumber(b) then
    b=a
   else
    b=b
  end
  return tonumber(b)
end
function 屏幕宽()
  local a = dm.widthPixels;
  local b = dm.heightPixels;
  if tonumber(a)>tonumber(b) then
    a=b
   else
    a=a
  end
  return tonumber(a)
end

local list={}
function setColor(a,b)
  local d,p
  if not list[a]
    list[a]={}
  end
  d=list[a]
  p=d[b]
  if p
    if _ENV[a]~=p
      _ENV[a]=p
    end
   else
    d[b]=Paint()
    d[b].set(_ENV[a])
    d[b].color=b
    _ENV[a]=d[b]
  end
end



function split2(szFullString, szSeparator)
  local nFindStartIndex = 1
  local nSplitIndex = 1
  local nSplitArray = Split_Table
  while true
    local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
    if not nFindLastIndex then
      nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
      break
    end
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
    nFindStartIndex = nFindLastIndex + string.len(szSeparator)
    nSplitIndex = nSplitIndex + 1
  end
  return nSplitArray
end

function split3(a,b)
  local idx=0
  a:gsub("[^"..b.."]+",function(w)
    idx=idx+1
    Split_Table[idx]=w
  end)
end

xpcall(function()
  split1=import "demo".split
end,function()
  split1=split2
end)

string.split=split1
Split_Table={}

draw=setmetatable({},{
  __newindex=function(self,key,value)
    if key=="ttf"
      local a=Typeface.createFromFile(File(activity.getLuaDir(tostring(value))))
      for k,v pairs(paint)
        v.setTypeface(a)
      end
    end
  end
})


function 振动(d)
  local a=activity.getSystemService(Context.VIBRATOR_SERVICE)
  local b=long{0,d}
  return lambda:a.vibrate(b,-1)
end

function MD提示(str,color,color2,ele,rad)
  if time then toasttime=Toast.LENGTH_SHORT else toasttime= Toast.LENGTH_SHORT end
  toasts={
    CardView;
    id="toastb",
    CardElevation=ele;
    radius=rad;
    backgroundColor=color;
    {
      TextView;
      layout_margin="7dp";
      textSize="13sp";
      TextColor=color2,
      text=str;
      layout_gravity="center";
      id="mess",
    };
  };
  local toast=Toast.makeText(activity,nil,toasttime);
  toast.setView(loadlayout(toasts))
  toast.show()
end


width=屏幕高()
height=屏幕宽()
width_2=width/2
height_2=height/2




local Runtime=luajava.bindClass("java.lang.Runtime")
local DataOutputStream=luajava.bindClass("java.io.DataOutputStream")
function su(...)
  local args={...}
  local process = Runtime.getRuntime().exec("su")
  local dos = DataOutputStream(process.getOutputStream());
  for k,v in ipairs(args) do
    dos.writeBytes(v.."\n");
    dos.flush();
  end
end
function 执行(name)
  local path = activity.getLuaDir(name)
  if ROOT
    su("chmod 777 "..path)
    su(path)
   else
    os.execute("chmod 777 "..path)
    Runtime.getRuntime().exec(path)
  end
end

local Color=luajava.bindClass'android.graphics.Color'
local tab={}
local hsv=float[3]
Color.colorToHSV(0xFF347F98,hsv)
local H,S,V=hsv[0],hsv[1],hsv[2]

function 随机颜色(num,a,s,v)
  when !a a=255
  when !s s=0
  when !v v=0
  if !tab[num]
    tab[num]={math.random(1,360)}
  end
  if !tab[num][tostring(a)..s..v]
    hsv[0],hsv[1],hsv[2]=(H+tab[num][1])%360,S+s,V+v
    tab[num][tostring(a)..s..v]=Color.HSVToColor(a,hsv)
  end
  return tab[num][tostring(a)..s..v]
end

function 清空颜色缓存()
  table.clear(tab)
end