# Données de test pour Check My Tension
patient = Patient.find_or_create_by!(nom: "Martin", prenom: "Sophie")

[
  { date: 7.days.ago.to_date, m_s: 128, m_d: 82, e_s: 122, e_d: 78 },
  { date: 6.days.ago.to_date, m_s: 135, m_d: 88, e_s: 130, e_d: 85 },
  { date: 5.days.ago.to_date, m_s: 120, m_d: 76, e_s: nil, e_d: nil },
  { date: 4.days.ago.to_date, m_s: 118, m_d: 74, e_s: 115, e_d: 72 },
  { date: 3.days.ago.to_date, m_s: 125, m_d: 80, e_s: 119, e_d: 77 },
].each do |data|
  TensionDay.find_or_create_by!(patient: patient, observation_date: data[:date]) do |td|
    td.morning_systolic = data[:m_s]
    td.morning_diastolic = data[:m_d]
    td.evening_systolic = data[:e_s]
    td.evening_diastolic = data[:e_d]
  end
end

puts "Seed terminé : #{Patient.count} patient(s), #{TensionDay.count} jour(s)"
