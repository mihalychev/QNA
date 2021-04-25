# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      before_action :find_question, only: %i[show update destroy]

      authorize_resource

      def index
        @questions = Question.all
        render json: @questions, each_serializer: QuestionsSerializer
      end

      def show
        render json: @question, serializer: QuestionSerializer
      end

      def create
        @question = current_resource_owner.questions.new(question_params)

        if @question.save
          render json: @question, serializer: QuestionSerializer
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @question.update(question_params)
          render json: @question, serializer: QuestionSerializer
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @question.destroy
      end

      private

      def find_question
        @question = Question.with_attached_files.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body, :category_id, links_attributes: %i[id name url _destroy])
      end
    end
  end
end
