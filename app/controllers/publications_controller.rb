class PublicationsController < ApplicationController
  def create
    job = Job.find(session[:job_id])

    JobPublisher.new(job).call

    flash[:notice] = "Ogłoszenie zostało opublikowane, informacje zostały wysłane na adres #{job.email}"
    redirect_to root_path
  end
end

