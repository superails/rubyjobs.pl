class Jobs::SummariesController < ApplicationController
  def show
    @job = Job.find(session[:job_id]).decorate
  end
end

