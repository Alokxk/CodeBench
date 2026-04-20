module Api
  module V1
    class ProblemsController < ApplicationController

      # GET /api/v1/problems
      # Returns all problems without expected_output
      def index
        problems = Problem.select(:id, :title, :description).order(:created_at)
        render json: problems
      end

      # GET /api/v1/problems/:id
      # Returns one problem without expected_output
      def show
        problem = Problem.find(params[:id])

        render json: {
          id:          problem.id,
          title:       problem.title,
          description: problem.description,
          input:       problem.input
        }
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Problem not found" }, status: :not_found
      end

    end
  end
end