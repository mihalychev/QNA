# frozen_string_literal: true

class NewAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    NewAnswerService.new.notify(answer)
  end
end
