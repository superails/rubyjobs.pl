class JobOffersController < ApplicationController
  helper_method :facet_slug_active?

  def index
    @filters = FacetedSearchBuilder.new(search_params).call

    if search_params.present?
      @job_offers = JobOffer.search(
        query: {
          bool: {
            must: search_params.to_h.map do |facet_name, facet_values|
              {
                terms: {
                  facet_name => facet_values
                }
              }
            end << {
              terms: {
                state: current_user.admin? ? ['published', 'submitted'] : ['published']
              }
            }
          }
        },
        sort: {
          "published_at": "desc"
        }
      ).records
    else
      @job_offers = JobOffer.published.order('published_at DESC')
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
    @job_offer = JobOfferCreator.new(job_offer_params).call

    if @job_offer.valid?
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
