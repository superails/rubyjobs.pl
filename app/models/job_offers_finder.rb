class JobOffersFinder
  attr_reader :search_params, :user

  def initialize(search_params, user)
    @search_params = search_params
    @user = user
  end

  def call
    Rails.cache.fetch("job_offers/#{user.id}/#{cache_key}") do 
      job_offers = JobOffer.with_attached_logo

      if search_params.present?
        job_offers = job_offers
          .joins(facets: :category)
          .where(facets: {slug: search_params.values.flatten})
          .group('job_offers.id')
          .having('COUNT(DISTINCT facet_categories.id) = ?', search_params.keys.length)
      end

      job_offers = 
        if user.admin?
          job_offers.active.order('published_at DESC, submitted_at DESC')
        else
          job_offers.published.order('published_at DESC').includes(:locations, :company)
        end
    end
  end

  private

  def cache_key
    Digest::SHA256.hexdigest search_params.to_s
  end
end
