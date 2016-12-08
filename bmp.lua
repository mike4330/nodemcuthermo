sda=5   -- GPIO2 connect to SDA BMP180
scl=6   -- GPIO0 connect to SCL BMP180
pres=0  -- pressure
temp=0  -- temperature
fare=0  -- temperature
oss=0   -- over sampling setting

function readBMP()
    bmp085.init(sda, scl)

    t = bmp085.temperature()
    t = (t/10)
    p = bmp085.pressure(3)
    p = (p/100)

    tf = (t*(9/5)+32)
    
    print ("bmp180 temperature value is: " ..tf )
    print ("bmp180 absolute pressure value is: "..p .."  millibars")
    -- release module
    bmp085 = nil
    package.loaded["bmp085"]=nil
end

print ("get first BMP reading\n")
readBMP()


tmr.alarm(0, 15000, tmr.ALARM_AUTO, function() readBMP() end) 
