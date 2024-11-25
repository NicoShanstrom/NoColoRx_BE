class Api::V1::DrugsController < ApplicationController
  def index
    drug_name = params[:drug_name]

    if drug_name.present?
      service = DrugService.new(drug_name)
      results = service.format_results
      render json: results, status: :ok
    else
      render json: { error: "Please provide a valid drug_name" }, status: :bad_request
    end
  rescue StandardError => e
    Rails.logger.error "Error fetching drug data: #{e.message}"
    render json: { error: "An error occurred while processing your request. Please try again later." }, status: :internal_server_error
  end
end
