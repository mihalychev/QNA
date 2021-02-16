# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      before_action :doorkeeper_authorize!

      private

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      # rubocop:disable Naming/MemoizedInstanceVariableName
      def current_ability
        @ability ||= Ability.new(current_resource_owner)
      end
      # rubocop:enable Naming/MemoizedInstanceVariableName
    end
  end
end
