SCHEDULER.every '10s' do
    # Create an instance of our helper class
    q = Graphite.new "http://graphite.formhub.org/"

    stat_name = "aliasByNode(sortByMaxima(summarize(servers.formhub_dot_org.monit.*.cpu.percent,\"5min\",\"avg\",true)),3)"

    # get the average over the last 5 mins
    proc_values = q.multi_values stat_name, "-5min"

    cpu_proc_list = []
    proc_values.each do |proc_value|
        cpu_proc_list << { label: proc_value[:target], value: proc_value[:value] }
    end
    
    send_event('cpu_proc_list', { items: cpu_proc_list })
end
