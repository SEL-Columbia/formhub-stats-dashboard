require "rest-client"
require "json"
require "date"
require "uri"

class Graphite
    # Pass in the url to where you graphite instance is hosted
    def initialize(url)
        @url = url
    end
    
    def get_value(datapoint)
        value = datapoint[0] || 0
        return value.round(2)
    end
    
    # This is the raw query method, it will fetch the
    # JSON from the Graphite and parse it
    def query(name, since=nil)
        since ||= '-2min'
        url = URI.escape("#{@url}/render?format=json&target=#{name}&from=#{since}")
        response = RestClient.get url
        result = JSON.parse(response.body, :symbolize_names => true)
        return result
    end
    
    # This is high-level function that will fetch a set of datapoints
    # since the given start point and convert it into a format that the
    # graph widget of Dashing can understand
    def points(name, since=nil)
        stats = query name, since
        datapoints = stats.first[:datapoints]
        
        points = []
        count = 1
        
        #(datapoints.select { |el| not el[0].nil? }).each do|item|
        datapoints.each do|item|
            points << { x: item[1], y: get_value(item)}
            count += 1
        end
        
        return points
    end
    
    # Not all Dashing widgets need a set of points, often just
    # the current value is enough. This method does just that, it fetches
    # the value for last point-in-time and returns it
    def value(name, since=nil)
        stats = query name, since
        last = stats.first[:datapoints].last
        
        return get_value(last)
    end
end
