$storage = Redis.new

def greater_then(current_value, rule_value)
  current_value > rule_value
end

def equal(current_value, rule_value)
  current_value == rule_value
end

# server
def key_name(params, rule)
  [params[:object], params[:value], rule[:operation]].join('_')
end

def object_rules(object)
  RULES.find_all { |rule| rule[:object] == object }
end

def server_request(params)
  result = {}

  object_rules(params[:object]).each do |rule|

    key = key_name(params, rule)

    $storage.rpush(key, Time.now.to_i)

    if rule[:period]
      slice_index = $storage.lrange(key, 0, -1).rindex {|time| (Time.now.to_i - rule[:period]) < time.to_i }
      $storage.ltrim(key, slice_index, -1)
    end

    l_value = $storage.llen(key)

    result[rule[:operation]] = send(rule[:operation], l_value, rule[:value])
  end

  result
end
