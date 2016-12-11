--utility to log syslog  to a remote host

function syslog(message)

--message="test syslog message "

srv=net.createConnection(net.UDP,0)
srv:connect(514, sysloghost)
srv:send("thermostat " .. message)
--print("Testing: " .. i)
srv:close()
end
