RULE = {
  object: :credit_card,
  #action: :request,
  #period: 2.hours,
  operation: :greater_then,
  count: 5
}

# actions
def greater_then(value)
  value > RULE[:count]
end

def equal(value)
  value == RULE[:count]
end

# server
def request(*args)
  if args[1] == RULE[:object]
    puts send(RULE[:operation], args[0]) ? 'YES' : 'NO'
  else
    puts "No rules found for '#{args[1]}'"
  end
end

# test app
objects = [:credit_card, :email, :ip]
(1..10).each do |i|
  object = objects.sample
  request(i, object)
end
