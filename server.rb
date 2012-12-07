$storage = Redis.new

def greater_then(current_value, rule_value)
  current_value > rule_value
end

def equal(current_value, rule_value)
  current_value == rule_value
end

# server
def key_name(params, operation)
  "#{params[:object]}_#{params[:value]}_#{operation}"
end

def object_rules(object)
  RULES.find_all { |rule| rule[:object] == object }
end

def server_request(params)
  result = {}
  
  object_rules(params[:object]).each do |rule|

    key = key_name(params, rule[:operation])

    $storage.sadd([key], Time.now.to_i)
    
    # $storage[key].delete_if {|time| (Time.now - rule[:period]) >= time } if rule[:period]
    
    if rule[:period]
      $storage.sdiff(key).each do |time|
        $storage.srem(key, time) if (Time.now.to_i - rule[:period]) >= time.to_i
      end
    end

    l_value = $storage.scard(key)

    result[rule[:operation]] = send(rule[:operation], l_value, rule[:value])
  end
  
  result
end