require "./lib/graphite"
current_mem_free = 0

# last started parkingsessions
SCHEDULER.every '10s', :first_in => 0 do
    # Create an instance of our helper class
    q = Graphite.new "http://graphite.formhub.org/"
    
    stat_name = "summarize(servers.formhub_dot_org.memory.MemFree,\"10min\",\"avg\",true)"
    
    last_mem_free = current_mem_free
    # get average for the last half hour
    current_mem_free = q.value stat_name, "-10min"
    current_mem_free = (current_mem_free/(1024**2)).round()
    
    # send to dashboard, so the number the meter and the graph widget can understand it
    send_event 'mem_free', { current: current_mem_free, last: last_mem_free }
end
