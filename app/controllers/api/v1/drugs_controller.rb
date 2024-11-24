class Api::V1::DrugsController < ApplicationController
  def index
    drug_name = params[:drug_name]
    dosage = params[:dosage]

    if drug_name.present? && dosage.present?
      service = DrugService.new(drug_name, dosage)
      results = service.filter_results

      render json: { results: results }, status: :ok
    else
      render json: { error: "Please provide both drug_name and dosage" }, status: :bad_request
    end
  end
end
