i=5

function syslog(message)

--message="test syslog message "

srv=net.createConnection(net.UDP,0)
srv:connect(514, "192.168.1.2")
srv:send("thermostat " .. message)
--print("Testing: " .. i)
srv:close()
end
