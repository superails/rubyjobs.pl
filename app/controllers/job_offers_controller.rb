class JobOffersController < ApplicationController
  def index
    if current_user.admin?
      @job_offers = JobOffer.active.submitted.order('published_at DESC, submitted_at DESC').decorate
    else
      @job_offers = JobOffer.active.published.order('published_at DESC').includes(:locations, :company).decorate
    end
  end

  def show
    @job_offer = JobOffer.find(params[:id]).decorate

    RegisterJobOfferVisitJob.perform_later(@job_offer.id) if @job_offer.published?
  end

  def new
    @job_offer = JobOffer.new
    @job_offer.build_company
  end

  def create
    @job_offer = JobOffer.new(job_offer_params)

    if @job_offer.save
      redirect_to job_offers_preview_path(@job_offer.token)
    else
      render :new
    end
  end

  def edit
    @job_offer = JobOffer.find_by(token: params[:token])
  end

  def update
    @job_offer = JobOffer.find_by(token: params[:token])

    if @job_offer.update(job_offer_params)
      redirect_to job_offers_preview_path(@job_offer.token)
    else
      render :edit
    end
  end

  private

  def job_offer_params
    params.require(:job_offer).permit(:title, :city_names, :remote, :salary, :salary_type, :description, :apply_link, :logo, :email, company_attributes: [:name])
  end
end
