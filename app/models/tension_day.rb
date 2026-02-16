class TensionDay < ApplicationRecord
  belongs_to :patient

  validates :observation_date, presence: { message: "est obligatoire" }
  validates :observation_date, uniqueness: { scope: :patient_id, message: "a déjà été utilisée pour ce patient" }

  TENSION_RANGE = 1..299
  TENSION_MESSAGE = "doit être entre 1 et 299"

  validates :morning_systolic, numericality: { in: TENSION_RANGE, message: TENSION_MESSAGE }, allow_nil: true
  validates :morning_diastolic, numericality: { in: TENSION_RANGE, message: TENSION_MESSAGE }, allow_nil: true
  validates :evening_systolic, numericality: { in: TENSION_RANGE, message: TENSION_MESSAGE }, allow_nil: true
  validates :evening_diastolic, numericality: { in: TENSION_RANGE, message: TENSION_MESSAGE }, allow_nil: true

  def morning_complete?
    morning_systolic.present? && morning_diastolic.present?
  end

  def evening_complete?
    evening_systolic.present? && evening_diastolic.present?
  end

  def complete?
    morning_complete? && evening_complete?
  end

  def morning_average
    return nil unless morning_complete?
    ((morning_systolic + morning_diastolic) / 2.0).round(1)
  end

  def evening_average
    return nil unless evening_complete?
    ((evening_systolic + evening_diastolic) / 2.0).round(1)
  end

  def daily_systolic_average
    values = [morning_systolic, evening_systolic].compact
    return nil if values.empty?
    (values.sum / values.size.to_f).round(1)
  end

  def daily_diastolic_average
    values = [morning_diastolic, evening_diastolic].compact
    return nil if values.empty?
    (values.sum / values.size.to_f).round(1)
  end
end
