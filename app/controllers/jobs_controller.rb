class JobsController < ApplicationController
  def index
    @jobs = Job.published.includes(:locations, :company).decorate
  end

  def show
    @job = Job.find(params[:id]).decorate
  end

  def new
    if session[:job_id]
      old_job = Job.find(session[:job_id])

      @job = old_job.dup
      @job.location = old_job.location 
      @job.remote = old_job.remote
      @job.company = old_job.company
    else
      @job = Job.new
      @job.build_company
    end
  end

  def create
    @job = Job.new(job_params)

    session[:job_id] = @job.id if @job.save

    redirect_to jobs_preview_path
  end

  private

  def job_params
    params.require(:job).permit(:title, :location, :remote, :salary, :salary_type, :description, :apply_link, :email, company_attributes: [:name, :logo])
  end
end
