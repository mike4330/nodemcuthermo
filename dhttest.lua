function readDHT()

pin = 2
status, temp, humi, temp_dec, humi_dec = dht.read(pin)
if status == dht.OK then
    -- Integer firmware using this example
    -- print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
          -- math.floor(temp),
          -- temp_dec,
          -- math.floor(humi),
          -- humi_dec
    -- ))

    -- Float firmware using this example
    dhtf=(temp*(9/5)+32)
	
	print("DHT Temperature:"..dhtf..";".."Humidity:"..humi)
    syslog("DHT Temperature:"..dhtf..";".."Humidity:"..humi)

elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
dht = nil
package.loaded["dht"]=nil
end

end

print "get initial DHT reading"
readDHT()

tmr.alarm(2, 25000, tmr.ALARM_AUTO, function() readDHT() end)
