

ntpserver='192.168.1.2'
--sntp.sync(ntpserver)

function syncntp()

sntp.sync(ntpserver, function() -- success
  print("INFO: Time Synchronized (via sntp). Current timestamp: "..rtctime.get())


tm = rtctime.epoch2cal(rtctime.get())

ftime=string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"])

--print (ftime)

print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))

sntp = nil
    package.loaded["sntp"]=nil

end)

end

print ("initial NTP sync with " .. ntpserver .. "\n")

syncntp()

tmr.alarm(1, 600000, tmr.ALARM_AUTO, function() syncntp() end)
