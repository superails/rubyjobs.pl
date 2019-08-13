class SummariesController < ApplicationController
  def show
    @job = Job.find(session[:job_id])
  end
end

