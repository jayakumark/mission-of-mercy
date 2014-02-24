class PatientChart < Prawn::Document
  def initialize(patient)
    super(top_margin: 20, left_margin: 20, right_margin: 20)
    @patient = patient
    chart_header
    chart_table
  end

  def chart_header
    text patient.chart_number.to_s, size: 36, style: :bold, align: :right
  end

  def chart_table
    table [
      [ label("Last name") + patient.last_name,
        label("First name") + patient.first_name,
        label("Date of birth") + patient.dob,
        label("Age") + patient.age.to_s,
        label("Phone") + phone_number,
        label("Gender") + patient.sex
      ],
      [
        label("Address") + patient.street,
        label("City") + patient.city,
        { content: label("State") + patient.state, colspan: 2 },
        { content: label("Zip")   + patient.zip,   colspan: 2 }
      ],
      [
        label("Reason for visit") + patient.chief_complaint,
        label("Last dental visit") + patient.last_dental_visit,
        { content: label("In pain?") + in_pain, colspan: 2 },
        { content: label("In pain for") + pain_length, colspan: 2 }
      ]
    ],
    cell_style: { inline_format: true, border_color: 'aaaaaa' },
    position: :center
  end

  private

  attr_reader :patient

  def label(text)
    "<font size='9'><color rgb='808080'>#{text}\n</color></font>"
  end

  def pain_length
    return "N/A" unless patient.pain? && patient.pain_length_in_days
    h.distance_of_time_in_words patient.pain_length_in_days.days.ago, Date.today
  end

  def phone_number
    h.number_to_phone(patient.phone.to_s.gsub(/[\(\)-\.]/,""), area_code: true)
  end

  def in_pain
    @patient.pain? ? 'Yes' : 'No'
  end

  def h
    ActionController::Base.helpers
  end
end
