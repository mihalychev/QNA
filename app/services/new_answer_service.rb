class NewAnswerService
  def notify(answer)
    answer.question.subscriptions.find_each(batch_size: 500) do |sub|
      NewAnswerMailer.notify(sub.user, answer).deliver_later
    end
  end
end