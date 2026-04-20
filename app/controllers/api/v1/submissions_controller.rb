module Api
  module V1
    class SubmissionsController < ApplicationController

      # POST /api/v1/submissions
      def create
        problem = Problem.find_by(id: params[:problem_id])
        unless problem
          render json: { error: "Problem not found" }, status: :not_found
          return
        end

        code = params[:code].to_s.strip
        if code.empty?
          render json: { error: "Code cannot be blank" }, status: :unprocessable_entity
          return
        end

        submission = Submission.create!(
          problem:  problem,
          code:     code,
          language: "python3",
          status:   "pending"
        )

        # Hand off to background worker — never execute code here
        CodeExecutionWorker.perform_async(submission.id)

        render json: submission_json(submission), status: :accepted
      end

      # GET /api/v1/submissions/:id
      def show
        submission = Submission.find_by(id: params[:id])
        unless submission
          render json: { error: "Submission not found" }, status: :not_found
          return
        end

        render json: submission_json(submission)
      end

      private

      def submission_json(submission)
        {
          id:         submission.id,
          problem_id: submission.problem_id,
          status:     submission.status,
          output:     submission.output,
          created_at: submission.created_at
        }
      end

    end
  end
end