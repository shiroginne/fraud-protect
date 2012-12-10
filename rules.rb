RULE1 = {
  object: :credit_card,
  operation: :greater_then,
  value: 3
}

RULE2 = {
  object: :credit_card,
  period: 15,
  operation: :equal,
  value: 3
}

RULE3 = {
  object: :email,
  operation: :greater_then,
  value: 2
}

RULES = [RULE1, RULE2, RULE3]
