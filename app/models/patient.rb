class Patient < ApplicationRecord
  has_many :tension_days, dependent: :destroy

  validates :nom, presence: { message: "est obligatoire" }
  validates :prenom, presence: { message: "est obligatoire" }
end
