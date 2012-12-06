RULE1 = {
  object: :credit_card,
  period: 3, # only seconds
  operation: :greater_then,
  value: 5
}

RULE2 = {
  object: :credit_card,
  period: 2,
  operation: :equal,
  value: 3
}

RULE3 = {
  object: :bad_password,
  period: 10,
  operation: :greater_then,
  value: 4
}

RULES = [RULE1, RULE2, RULE3]

$start_time = Time.now
$storage    = Hash.new { |h,k| h[k] = 0 }

# actions
def greater_then(current_value, rule_value)
  current_value > rule_value
end

def equal(current_value, rule_value)
  current_value == rule_value
end

def check_period?(rule_period)
  (Time.now - $start_time) <= rule_period
end

# server
def request(object)
  $storage[object] += 1

  result = {}
  object_rules(object).each do |rule|
    result[rule[:operation]] = check_period?(rule[:period]) && send(rule[:operation], $storage[object], rule[:value])
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

  # object = objects.sample
  object = :bad_password
  result = request(object)
  puts "Request '#{object}' is '#{result}'"
end
