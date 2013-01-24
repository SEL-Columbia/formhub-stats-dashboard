require "./lib/graphite"
current_cpu = 0

# last started parkingsessions
SCHEDULER.every '10s', :first_in => 0 do
    last_cpu = current_cpu
    # Create an instance of our helper class
    q = Graphite.new "http://graphite.formhub.org/"
    
    stat_name = "summarize(servers.formhub_dot_org.cpu.total.user,\"10min\",\"avg\",true)"
    
    # get average for the last half hour
    current_cpu = q.value stat_name, "-10min"
    
    # send to dashboard, so the number the meter and the graph widget can understand it
    send_event 'cpu', { current: current_cpu, last: last_cpu }
end
