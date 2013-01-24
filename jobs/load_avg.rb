require "./lib/graphite"

# last started parkingsessions
SCHEDULER.every '10s', :first_in => 0 do
    # Create an instance of our helper class
    q = Graphite.new "http://graphite.formhub.org/"
    
    stat_name = "summarize(asPercent(servers.formhub_dot_org.loadavg.processes_running,servers.formhub_dot_org.loadavg.processes_total),\"5min\",\"avg\",true)"
    
    # get average for the last half hour
    load_avg = q.value stat_name, "-5min"
    load_avg = load_avg.round(2)
    
    # send to dashboard, so the number the meter and the graph widget can understand it
    send_event 'load_avg', { value: load_avg }
end
