class JobOffersController < ApplicationController
  helper_method :facet_slug_active?

  def index
    @job_offers = JobOffer.all
    @filters = FacetedSearchBuilder.new(search_params).call

    @job_offers = JobOffer.joins(:facets).where(facets: {slug: search_params.values.flatten}).distinct if search_params.present?

    @job_offers = 
      if current_user.admin?
        @job_offers.active.order('published_at DESC, submitted_at DESC')
      else
        @job_offers.published.order('published_at DESC').includes(:locations, :company)
      end


    @job_offers = @job_offers.decorate
  end

  def show
    @job_offer = JobOffer.find(params[:id]).decorate

    flash[:notice] = 'Ogłoszenie jest już nieaktualne.' if @job_offer.closed?

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

  def search_params
    params.permit(location: [], experience: [])
  end

  def facet_slug_active?(facet_slug)
    search_params.values.flatten.include?(facet_slug)
  end

  def job_offer_params
    params.require(:job_offer).permit(:title, :city_names, :remote, :salary, :salary_type, :description, :apply_link, :logo, :email, company_attributes: [:name])
  end
end
