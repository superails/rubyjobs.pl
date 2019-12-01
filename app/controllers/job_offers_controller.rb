class JobOffersController < ApplicationController
  def index
    @job_offers = JobOffer.all

    if params[:q].present?
      tsquery = "to_tsquery('simple', '#{params[:q].split(/\s+/).join(' & ')}')"

      job_offers_with_location_names = JobOffer.
        select("job_offers.*, string_agg(locations.name, ', ') AS location_names").
        joins(:locations).
        group('job_offers.id')

      @job_offers = JobOffer.from(job_offers_with_location_names, :job_offers).
        where("to_tsvector('simple', concat_ws(' ', location_names, title)) @@ #{tsquery}")
    end

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
