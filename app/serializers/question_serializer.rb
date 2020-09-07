class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :short_title, :files

  has_many :comments
  has_many :links

  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map { |file| { url: rails_blob_url(file, only_path: true) } }
  end
end
