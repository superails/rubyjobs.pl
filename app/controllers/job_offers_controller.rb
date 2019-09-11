class JobOffersController < ApplicationController
  def index
    @job_offers = JobOffer.published.includes(:locations, :company).decorate
  end

  def show
    @job_offer = JobOffer.find(params[:id]).decorate
  end

  def new
    if session[:job_offer_id]
      old_job_offer = JobOffer.find(session[:job_offer_id])

      @job_offer = old_job_offer.dup
      @job_offer.city_names = old_job_offer.city_names
      @job_offer.remote = old_job_offer.remote
      @job_offer.company = old_job_offer.company
    else
      @job_offer = JobOffer.new
      @job_offer.build_company
    end
  end

  def create
    @job_offer = JobOffer.new(job_offer_params)

    if @job_offer.save
      session[:job_offer_id] = @job_offer.id 
      redirect_to job_offers_preview_path
    else
      render :new
    end
  end

  private

  def job_offer_params
    params.require(:job_offer).permit(:title, :city_names, :remote, :salary, :salary_type, :description, :apply_link, :email, company_attributes: [:name, :logo])
  end
end
