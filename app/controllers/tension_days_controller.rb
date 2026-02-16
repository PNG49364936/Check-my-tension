class TensionDaysController < ApplicationController
  before_action :set_patient
  before_action :set_tension_day, only: [:edit, :update, :destroy]

  def new
    @tension_day = @patient.tension_days.build
    @mode = params[:mode] || "morning"
  end

  def create
    @tension_day = @patient.tension_days.build(tension_day_params)
    if @tension_day.save
      redirect_to patient_path(@patient), notice: "Mesures enregistrées avec succès."
    else
      @mode = params[:mode] || "morning"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @mode = params[:mode] || "full"
  end

  def update
    if @tension_day.update(tension_day_params)
      redirect_to patient_path(@patient), notice: "Mesures mises à jour avec succès."
    else
      @mode = params[:mode] || "full"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tension_day.destroy
    redirect_to patient_path(@patient), notice: "Jour supprimé avec succès."
  end

  def results
    @tension_days = @patient.tension_days.order(:observation_date)
    selected_ids = params[:day_ids]&.map(&:to_i)
    @selected_days = selected_ids.present? ? @tension_days.select { |d| selected_ids.include?(d.id) } : []
  end

  def export_pdf
    @tension_days = @patient.tension_days.order(:observation_date)
    selected_ids = params[:day_ids]&.map(&:to_i) || []
    @selected_days = @tension_days.select { |d| selected_ids.include?(d.id) }

    pdf = generate_pdf(@patient, @selected_days)

    send_data pdf.render,
              filename: "tension_#{@patient.nom}_#{@patient.prenom}_#{Date.today}.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_tension_day
    @tension_day = @patient.tension_days.find(params[:id])
  end

  def tension_day_params
    params.require(:tension_day).permit(
      :observation_date,
      :morning_systolic,
      :morning_diastolic,
      :evening_systolic,
      :evening_diastolic
    )
  end

  def generate_pdf(patient, days)
    require "prawn"
    require "prawn/table"

    pdf = Prawn::Document.new(page_size: "A4", page_layout: :landscape)

    pdf.font_families.update("DejaVu" => {
      normal: "#{Rails.root}/vendor/fonts/DejaVuSans.ttf",
      bold: "#{Rails.root}/vendor/fonts/DejaVuSans-Bold.ttf"
    }) if File.exist?("#{Rails.root}/vendor/fonts/DejaVuSans.ttf")

    pdf.text "Relevé de tension artérielle", size: 18, style: :bold
    pdf.text "Patient : #{patient.prenom} #{patient.nom}", size: 14
    pdf.text "Généré le #{I18n.l(Date.today, format: :long)}", size: 10
    pdf.move_down 20

    headers = ["Date", "Matin Syst.", "Matin Diast.", "Soir Syst.", "Soir Diast.", "Moy. Syst.", "Moy. Diast."]

    rows = days.map do |day|
      [
        I18n.l(day.observation_date, format: :default),
        day.morning_systolic || "-",
        day.morning_diastolic || "-",
        day.evening_systolic || "-",
        day.evening_diastolic || "-",
        day.daily_systolic_average || "-",
        day.daily_diastolic_average || "-"
      ]
    end

    if rows.any?
      all_systolic = days.map(&:daily_systolic_average).compact
      all_diastolic = days.map(&:daily_diastolic_average).compact
      if all_systolic.any?
        rows << [
          "MOYENNE GLOBALE",
          "-", "-", "-", "-",
          (all_systolic.sum / all_systolic.size).round(1),
          (all_diastolic.sum / all_diastolic.size).round(1)
        ]
      end
    end

    table_data = [headers] + rows
    pdf.table(table_data, header: true, width: pdf.bounds.width) do
      row(0).background_color = "2D4A6B"
      row(0).text_color = "FFFFFF"
      row(0).font_style = :bold
      row(-1).background_color = "E8F4F8" if rows.any?
      cells.borders = [:top, :bottom, :left, :right]
      cells.padding = [5, 8]
    end

    pdf
  end
end
