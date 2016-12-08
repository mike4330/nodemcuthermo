sp = 68
gpin=3
mode = 1 --heat
mode = 2 --cool
mode = 3 --off

thermostatus = "off"

dofile("css.lua")

-- LUA Webserver --
-- a simple http server
if srv~=nil then
  srv:close()
end

srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
    conn:on("receive",function(conn,payload) 
    print(payload) 

    if string.match(payload, "?up") then
	print ("adjust setpoint up.")
	sp = (sp+1)
	end

    if string.match(payload, "?down") then
    print ("adjust setpoint down.")
    sp = (sp-1)
    end
    
    output = '<html><meta name="viewport" content="width=device-width, initial-scale=1"><head>' ..rowst..'</head>'
    output = output .. '<body style="max-width:500px;font-family:sans-serif;">'
    
    output = output .. ' <table align=center bgcolor=#ededed style="valign: middle;border-spacing: 8px;box-shadow: 8px 8px 6px #888888;border: 2px solid #87231C;">'
    
	output = output .. ' <tr><td style="font-size: 1.5em;text-align: center;" colspan=4>NodeMCU ' .. appname .. "  " .. appv .. "</td></tr>"
	
    output = output.. '<tr><td>temperature </td><td style="font-size: 2em;border: 1px solid #888888;" colspan=3>'  .. dhtf .. ' F</td></tr> <br>'
   
	
    output = output .. '<tr><td>Set Point</td><td style="font-size: 2em;border: 1px solid #888888;" colspan=3>' .. sp .. '</td></tr>'
    output = output .. '<tr><td>System Status</td><td style="font-size: 2em;border: 1px solid #888888;" colspan=3>' .. thermostatus .. '</td></tr>'
	output = output.. "<tr><td>Humidity</td> <td colspan=3>" .. humi .. " %</td><br>"
    output = output.. "<tr><td>abs. pressure</td> <td colspan=3>" .. p .. " millibars</td><br>"
	
    tm = rtctime.epoch2cal(rtctime.get())

    ftime=string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"])
	
    output = output.. "<tr><td>current time</td><td colspan=3>" .. ftime .. "</td></tr><br>"
    
	--button row
	
	output = output .. '<tr ><td id="brow"><a href="?up"><button class=mybutton>&#8679;</button></a></td>'
	output = output .. '<td id="brow"><a href="?down"><button class=mybutton>&#8681;</button></a></td><td id="brow"><button class=mybutton>'..mode..'</button></td><td id="brow"><button class=mybutton>&#9881;</button></td>'
   
    output = output.. "</tr>'</table></body></html>"
    conn:send(output)
    conn:on("sent",function(conn) conn:close() end)
    --conn:send("temp" .. temp)
    end) 

end)

function checkthermo()

spdiff = (sp-dhtf)

print ("set point differential is" ..spdiff)

--heating mode, warmer than set point

if mode==1 and spdiff < 0 then
    print ("thermo is in heating mode, temp higher than setpoint, doing nothing")
	syslog ("thermo is in heating mode, temp higher than setpoint, doing nothing")
	
	gpio.mode(gpin, gpio.OUTPUT)
	gpio.write(gpin, gpio.HIGH)

	thermostatus="off"
    end

if mode==1 and spdiff > 0 then
    print ("thermo is in heating mode, temp lower than setpoint, turn heat on")
	
	gpio.mode(gpin, gpio.OUTPUT)
	gpio.write(gpin, gpio.LOW)

	syslog ("thermo is in heating mode, temp lower than setpoint, turn heat on")
	thermostatus="heating"
    end

if mode==3 then 
    print("thermostat is OFF, doing nothing")
    end

end

tmr.alarm(3, 25000, tmr.ALARM_AUTO, function() checkthermo() end)
