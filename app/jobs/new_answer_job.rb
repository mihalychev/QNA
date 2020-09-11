class NewAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    NewAnswer.new.notify(answer)
  end
end
