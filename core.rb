require File.expand_path(File.join(Dir.pwd, 'rules.rb'))

$storage = Hash.new { |h,k| h[k] = [] }

# actions
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

def request(params)
  result = {}
  
  object_rules(params[:object]).each do |rule|
    key = key_name(params, rule[:operation])
    
    $storage[key] << Time.now
    $storage[key].delete_if {|time| (Time.now - rule[:period]) >= time } if rule[:period]

    l_value = $storage[key].count

    result[rule[:operation]] = send(rule[:operation], l_value, rule[:value])
  end

  result
end

def object_rules(object)
  RULES.find_all { |rule| rule[:object] == object }
end

# test app
objects = [:credit_card, :bad_password, :ip]
1.upto(2_000_000).each do |i|
  
  result = request({ object: :credit_card, value: i.to_s })
end
