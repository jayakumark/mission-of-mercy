class TreatmentAreas::Patients::PrescriptionsController < CheckoutController
  before_filter :authenticate_user!

  def index
    @patient.patient_prescriptions.each do |p|
      p.prescribed = true
    end

    Prescription.all.each do |pres|
      unless @patient.prescriptions.exists? pres
        @patient.patient_prescriptions.build(:prescription_id => pres.id)
      end
    end

    @prescriptions = @patient.patient_prescriptions.sort_by {|p| p.prescription.position || -1 }
  end

  def update
    new_prescription = false

    @patient.attributes = patient_params

    @patient.patient_prescriptions.each do |p|
      new_prescription = true if p.new_record?
    end

    @patient.save

    @patient.check_out(@treatment_area)

    if new_prescription
      @patient.flows.create(:area_id => ClinicArea::PHARMACY)
    end

    flash[:notice] = "Patient successfully checked out"
    stats.patient_checked_out

    redirect_to treatment_area_patients_path(@treatment_area)
  end

  private

  def patient_params
    params.require(:patient).permit!
  end
end
