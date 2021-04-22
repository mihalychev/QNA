# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :files, :created_at, :updated_at, :user_id

  has_many :comments
  has_many :links

  def files
    object.files.map { |file| { url: rails_blob_url(file, only_path: true) } }
  end
end
