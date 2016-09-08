And(/^the \w+ model of that feature model$/) do |code_text|
  eval(code_text)
end

And(/^the \w+(?: \w+)? model inside of that feature model$/) do |code_text|
  eval(code_text)
end
