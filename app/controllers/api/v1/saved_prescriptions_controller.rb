class Api::V1::SavedPrescriptionsController < ApplicationController
  before_action :authenticate_user

  def index
    prescriptions = current_user.saved_prescriptions
    render json: prescriptions, status: :ok
  end

  def create
    saved_prescription = current_user.saved_prescriptions.new(saved_prescription_params)

    if saved_prescription.save
      render json: SavedPrescriptionSerializer.new(saved_prescription), status: :created
    else
      render json: { errors: saved_prescription.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    prescription = current_user.saved_prescriptions.find(params[:id])
    prescription.destroy
    render json: { message: "Prescription deleted successfully" }, status: :ok
  end

  private

  def saved_prescription_params
    params.require(:saved_prescription).permit(
      :drug_name,
      :manufacturer,
      :package_label_principal_display_panel,
      fields: [],
      metadata: {}
    )
  end

  def authenticate_user
    render json: { error: "Unauthorized" }, status: :unauthorized unless session[:user_id] && current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
