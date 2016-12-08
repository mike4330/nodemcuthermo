dofile("credentials.lua")
dofile("parms.lua")
dofile("syslog.lua")


function startup()
    if file.open("start.lua") == nil then
        print("init.lua deleted or renamed")
    else
        print("Running")
        file.close("start.lua")
        
         smessage = appname .. " " .. appv .. " starting up "
         syslog(smessage)
         dofile("ntp.lua")
         dofile("bmp.lua")
         
         dofile("dhttest.lua")
         print ("dht sensor started")
         
         print ("starting thermostat routine")
         dofile("thermostat.lua")
         print("thermostat started")
         syslog("thermostat started")
    end
end

print("Connecting to WiFi access point...")
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID, PASSWORD)
-- wifi.sta.connect() not necessary because config() uses auto-connect=true by default
tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("Waiting for IP address...")
    else
        tmr.stop(1)
        print("WiFi connection established, IP address: " .. wifi.sta.getip())
        

        print("You have 8 seconds to abort")
        print("Waiting...")
        tmr.alarm(0, 8000, 0, startup)
    end
end)


