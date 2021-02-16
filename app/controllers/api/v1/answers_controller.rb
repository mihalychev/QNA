# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :find_answer, only: %i[show update destroy]
      before_action :find_question, only: %i[index create]

      authorize_resource

      def index
        render json: @question.answers, each_serializer: AnswersSerializer
      end

      def show
        render json: @answer, serializer: AnswerSerializer
      end

      def create
        @answer = @question.answers.new(answer_params.merge(user: current_resource_owner))

        if @answer.save
          render json: @answer, serializer: AnswerSerializer
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @answer.update(answer_params)
          render json: @answer, serializer: AnswerSerializer
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @answer.destroy
      end

      private

      def find_answer
        @answer = Answer.with_attached_files.find(params[:id])
      end

      def find_question
        @question = Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
      end
    end
  end
end
