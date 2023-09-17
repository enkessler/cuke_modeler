When(/^the models are compared$/) do
  @results = []

  (@models.count - 1).times do |index|
    @results << (@models[index] == @models[index + 1])
  end

  @results << (@models.first == @models.last)
end
