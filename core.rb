RULE1 = {
  object: :credit_card,
  period: 12,
  operation: :greater_then,
  value: 9
}

RULE2 = {
  object: :credit_card,
  period: 5,
  operation: :equal,
  value: 3
}

RULE3 = {
  object: :bad_password,
  period: 10,
  operation: :greater_then,
  value: 5
}

RULE4 = {
  object: :bad_password,
  operation: :equal,
  value: 5
}

RULES = [RULE1, RULE2, RULE3, RULE4]

$storage    = Hash.new { |h,k| h[k] = Hash.new {|ih,ik| ih[ik] = [] } }

# actions
def greater_then(current_value, rule_value)
  current_value > rule_value
end

def equal(current_value, rule_value)
  current_value == rule_value
end

# server
def request(object)
  result = {}
  object_rules(object).each do |rule|

    $storage[object][rule[:operation]] << Time.now
    $storage[object][rule[:operation]].delete_if {|time| (Time.now - rule[:period]) >= time } if rule[:period]

    result[rule[:operation]] = send(rule[:operation], $storage[object][rule[:operation]].count, rule[:value])
  end

  result
end

def object_rules(object)
  RULES.find_all { |rule| rule[:object] == object }
end

# test app
objects = [:credit_card, :bad_password, :ip]
(1..20).each do |i|
  sleep(1)
  puts "sleep #{'.'*i} #{i}"

  object = :bad_password
  result = request(object)
  puts "Request '#{object}' is '#{result}'"
end
