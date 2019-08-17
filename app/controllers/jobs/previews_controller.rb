class Jobs::PreviewsController < ApplicationController
  def show
    @job = Job.find(session[:job_id]).decorate
  end
end

