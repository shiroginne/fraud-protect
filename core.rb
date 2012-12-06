RULE1 = {
  object: :credit_card,
  #action: :request,
  #period: 2.hours,
  operation: :greater_then,
  value: 5
}

RULE2 = {
  object: :credit_card,
  #action: :request,
  #period: 2.hours,
  operation: :equal,
  value: 3
}

RULES = [RULE1, RULE2]

$storage = Hash.new { |h,k| h[k] = 0 }

# actions
def greater_then(current_value, rule_value)
  current_value > rule_value
end

def equal(current_value, rule_value)
  current_value == rule_value
end

# server
def request(object)
  $storage[object] += 1

  result = {}
  object_rules(object).each do |rule|
    result[rule[:operation]] = send(rule[:operation], $storage[object], rule[:value])
  end

  result
end

def object_rules(object)
  RULES.find_all { |rule| rule[:object] == object }
end

# test app
objects = [:credit_card, :email, :ip]
(1..20).each do
  object = objects.sample
  result = request(object)
  puts "Request '#{object}' is '#{result}'"
end
