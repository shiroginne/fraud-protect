RULE = {
  object: :credit_card,
  #action: :request,
  #period: 2.hours,
  operation: :greater_then,
  count: 5
}

$storage = Hash.new { |h,k| h[k] = 0 }

# actions
def greater_then(value)
  value > RULE[:count]
end

def equal(value)
  value == RULE[:count]
end

# server
def request(object)
  $storage[object] += 1

  if object == RULE[:object]
    puts send(RULE[:operation], $storage[object]) ? 'YES' : 'NO'
  else
    puts "No rules found for '#{object}'"
  end
end

# test app
objects = [:credit_card, :email, :ip]
(1..20).each do
  object = objects.sample
  request(object)
end
