--peripherals
dial = peripheral.wrap('left')

--config
maxText = 15
xminTot = 2
yminTot = 2
butPerLine = 2
butHeight = 3
butWidth = 17
dimensionsCount = dial.getReceiverCount()

--start ButonAPI by Direwolf20(modified)
monitors = {peripheral.find("monitor")}
local mon = {}
for funcName,_ in pairs(monitors[1]) do
	mon[funcName] = function(...)
		for i=1,#monitors-1 do monitors[i][funcName](unpack(arg)) end
		return monitors[#monitors][funcName](unpack(arg))
	end
end

mon.setTextScale(1)
mon.setTextColor(colors.white)
button={}
mon.setBackgroundColor(colors.black)

function clearTable()
   button = {}
end

function setButton(name, buttonOn)
   print(name)
   print(button[name]["active"])
   button[name]["active"] = buttonOn
   screen()
end
                                             
function setTable(name, func, param, xmin, xmax, ymin, ymax)
   button[name] = {}
   button[name]["func"] = func
   button[name]["active"] = false
   button[name]["param"] = param
   button[name]["xmin"] = xmin
   button[name]["ymin"] = ymin
   button[name]["xmax"] = xmax
   button[name]["ymax"] = ymax
end

function funcName()
   print("You clicked buttonText")
end
        
function fillTable()
   setTable("ButtonText", funcName, 5, 25, 4, 8)
end     

function fill(text, color, bData)
   mon.setBackgroundColor(color)
   local yspot = math.floor((bData["ymin"] + bData["ymax"]) /2)
   local xspot = math.floor((bData["xmax"] - bData["xmin"] - string.len(text)) /2) +1
   for j = bData["ymin"], bData["ymax"] do
      mon.setCursorPos(bData["xmin"], j)
      if j == yspot then
         for k = 0, bData["xmax"] - bData["xmin"] - string.len(text) +1 do
            if k == xspot then
               mon.write(text)
            else
               mon.write(" ")
            end
         end
      else
         for i = bData["xmin"], bData["xmax"] do
            mon.write(" ")
         end
      end
   end
   mon.setBackgroundColor(colors.black)
end
     
function screen()
   local currColor
   for name,data in pairs(button) do
      local on = data["active"]
      if on == true then currColor = colors.lime else currColor = colors.red end
      fill(name, currColor, data)
   end
end

function toggleButton(name)
   button[name]["active"] = not button[name]["active"]
   screen()
end     

function flash(name)
   toggleButton(name)
   screen()
   sleep(0.15)
   toggleButton(name)
   screen()
end
                                             
function checkxy(x, y)
   for name, data in pairs(button) do
      if y>=data["ymin"] and  y <= data["ymax"] then
         if x>=data["xmin"] and x<= data["xmax"] then
            if data["param"] == "" then
              data["func"]()
            else
              data["func"](data["param"])
            end
            for name, info in pairs(button) do
              info['active'] = false
            end
            data['active'] = true
            screen()
            return true
            --data["active"] = not data["active"]
            --print(name)
         end
      end
   end
   return false
end
     
function heading(text)
   w, h = mon.getSize()
   mon.setCursorPos((w-string.len(text))/2+1, 1)
   mon.write(text)
end
     
function label(w, h, text)
   mon.setCursorPos(w, h)
   mon.write(text)
end
--end buttonAPI

--set dimension function setDim
function setDim(transID) 
  dial.dial(0,transID)
end

--create buttons

--set buttons in for-loop
for i = 0, dimensionsCount - 1, 1 do 
  xmin = xminTot + ((i % butPerLine) * (butWidth + 2))
  xmax = xmin + butWidth - 1
  ymin = yminTot + (math.floor(i / butPerLine) * (butHeight + 2))
  ymax = ymin + butHeight - 1
  dimName = dial.getReceiverName(i)  
  dimID = i
  
  print(dimName)
  
  setTable(string.sub(dimName, 1, 15), setDim, dimID, xmin, xmax, ymin, ymax)
end

screen()

while true do
  event, side, xPos, yPos = os.pullEvent('monitor_touch')
  checkxy(xPos, yPos)
end