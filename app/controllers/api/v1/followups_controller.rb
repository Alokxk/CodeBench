module Api
  module V1
    class FollowupsController < ApplicationController

      # POST /api/v1/problems/:problem_id/followup
      def create
        problem    = Problem.find_by(id: params[:problem_id])
        submission = Submission.find_by(id: params[:submission_id])

        unless problem && submission
          render json: { error: "Problem or submission not found" }, status: :not_found
          return
        end

        unless submission.status == "accepted"
          render json: { error: "Followup only available for accepted submissions" }, status: :unprocessable_entity
          return
        end

        questions = GeminiService.generate_followup_questions(
          problem.title,
          problem.description,
          submission.code
        )

        render json: { questions: questions }

      rescue => e
        render json: { error: "Failed to generate questions: #{e.message}" }, status: :service_unavailable
      end

      # POST /api/v1/problems/:problem_id/followup/evaluate
      def evaluate
        problem = Problem.find_by(id: params[:problem_id])

        unless problem
          render json: { error: "Problem not found" }, status: :not_found
          return
        end

        questions = params[:questions]
        answers   = params[:answers]

        if questions.blank? || answers.blank? || questions.length != answers.length
          render json: { error: "Invalid questions or answers" }, status: :unprocessable_entity
          return
        end

        results = GeminiService.evaluate_answers(
          problem.title,
          questions,
          answers
        )

        render json: { results: results }

      rescue => e
        render json: { error: "Failed to evaluate answers: #{e.message}" }, status: :service_unavailable
      end

    end
  end
end