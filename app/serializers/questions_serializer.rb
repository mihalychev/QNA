# frozen_string_literal: true

class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :short_title, :body, :created_time, :created_date

  def short_title
    object.title.truncate(100)
  end

  def created_time
    object.created_at.strftime('%H:%M')
  end

  def created_date
    object.created_at.strftime('%d.%m.%Y')
  end
end
