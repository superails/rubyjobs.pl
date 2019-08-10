class JobsController < ApplicationController
  def index
  end

  def new
    @job = Job.new
    @job.build_company
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
