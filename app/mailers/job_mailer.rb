class JobMailer < ApplicationMailer
  def summary
    job = Job.find(params[:id])

    mail(to: job.email, subject: "Twoje ogłoszenie na rubyjobs.pl zostało dodane")
  end
end
