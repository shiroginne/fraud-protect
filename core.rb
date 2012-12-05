RULE = {
  #object: :credit_card,
  #action: :request,
  #period: 2.hours,
  operation: :greater_then,
  count: 5
}

def greater_then(value)
  value > RULE[:count]
end

def equal(value)
  value == RULE[:count]
end





#-------------------------------------------------------
def request(*arg)
  puts send(RULE[:operation], arg[0]) ? 'YES' : 'NO'
end

(1..10).each do |i|
  request(i)
end
