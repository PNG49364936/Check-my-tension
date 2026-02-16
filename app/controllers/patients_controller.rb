class PatientsController < ApplicationController
  def index
    @patients = Patient.order(:nom, :prenom)
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)
    if @patient.save
      redirect_to patient_path(@patient), notice: "Patient créé avec succès."
    else
      @patients = Patient.order(:nom, :prenom)
      render :index, status: :unprocessable_entity
    end
  end

  def show
    @patient = Patient.find(params[:id])
    @tension_days = @patient.tension_days.order(observation_date: :desc)
    @incomplete_days = @tension_days.select { |d| !d.evening_complete? }
  end

  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy
    redirect_to root_path, notice: "Patient supprimé avec succès."
  end

  private

  def patient_params
    params.require(:patient).permit(:nom, :prenom)
  end
end
