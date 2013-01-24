require "./lib/graphite"

# last started parkingsessions
SCHEDULER.every '1m', :first_in => 0 do
    # Create an instance of our helper class
    q = Graphite.new "http://graphite.formhub.org/"
    
    stat_name = "summarize(servers.formhub_dot_org.diskspace.root.byte_avail,\"30min\",\"avg\",true)"
    
    # get average for the last half hour
    space_avail = q.value stat_name, "-30min"
    space_avail = (space_avail/(1024**2)).round()
    
    # send to dashboard, so the number the meter and the graph widget can understand it
    send_event 'diskspace', { value: space_avail }
end
