# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :user_id, :files

  has_many :comments
  has_many :links

  def files
    object.files.map { |file| { url: rails_blob_url(file, only_path: true) } }
  end
end
