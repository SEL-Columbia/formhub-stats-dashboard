SCHEDULER.every '10s' do
    # Create an instance of our helper class
    q = Graphite.new "http://graphite.formhub.org/"

    stat_name = "aliasByNode(sortByMaxima(summarize(servers.formhub_dot_org.monit.*.memory.byte_usage,\"5min\",\"avg\",true)),3)"

    # get the average over the last 5 mins
    proc_values = q.multi_values stat_name, "-5min"

    mem_proc_list = []
    proc_values.each do |proc_value|
        mem_proc_list << { label: proc_value[:target], value: (proc_value[:value]/(1024**2)).round(2) }
    end
    
    send_event('mem_proc_list', { items: mem_proc_list })
end
