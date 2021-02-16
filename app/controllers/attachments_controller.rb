# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_file

  def destroy
    authorize! :destroy, @file
    @file.purge
  end

  private

  def find_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end
end
