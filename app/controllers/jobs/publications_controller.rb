class Jobs::PublicationsController < ApplicationController
  def create
    job = Job.find(session[:job_id])

    JobPublisher.new(job).call

    session.delete(:job_id)

    flash[:notice] = "Ogłoszenie zostało opublikowane, informacje zostały wysłane na adres #{job.email}"
    redirect_to root_path
  end
end

