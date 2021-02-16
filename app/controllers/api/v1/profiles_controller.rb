# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      authorize_resource class: User

      def index
        @profiles = User.where.not(id: current_resource_owner.id)
        render json: @profiles, each_serializer: ProfileSerializer
      end

      def me
        render json: current_resource_owner, serializer: ProfileSerializer
      end
    end
  end
end
