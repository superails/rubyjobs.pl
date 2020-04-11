class JobOffersController < ApplicationController
  helper_method :facet_slug_active?

  def index
      response = JobOffer.search(
        query: {
          bool: {
            must: search_params.to_h.map do |facet_name, facet_values|
              {
                nested: {
                  path: facet_name,
                  query: {
                    terms: {
                      "#{facet_name}.slug" => facet_values
                    }
                  }
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
        },
        aggs: {
          all_job_offers: {
            global: {},
            aggs: JobOffer::FACET_SLUGS.map do |facet_name|
              [
                facet_name, 
                {
                  nested: {
                    path: facet_name
                  },
                  aggs: {
                    slug: {
                      terms: {
                        field: "#{facet_name}.slug",
                        order: [{_count: "desc"}, {_key: "asc"}]
                      },
                      aggs: {
                        name: {
                          terms: {
                            field: "#{facet_name}.name"
                          }
                        }
                      }
                    }
                  }
                }
              ]
            end.to_h
          },
          filtered_job_offers: {
            global: {},
            aggs: JobOffer::FACET_SLUGS.map do |facet_name|
              [
                "filtered_#{facet_name}",
                {
                  filter: {
                    bool: {
                      must: search_params.to_h.except(facet_name).map do |other_facet_name, other_facet_values|
                        {
                          nested: {
                            path: other_facet_name,
                            query: {
                              terms: {
                                "#{other_facet_name}.slug" => other_facet_values
                              }
                            }
                          }
                        }
                      end
                    }
                  },
                  aggs: {
                    facet_name => {
                      nested: {
                        path: facet_name
                      },
                      aggs: {
                        slug: {
                          terms: {
                            field: "#{facet_name}.slug",
                            min_doc_count: 0
                          }
                        }
                      }
                    }
                  }
                }
              ]
            end.to_h
          }
        }
      )

      @filters = response.response.aggregations.all_job_offers.slice(*JobOffer::FACET_SLUGS).map do |k,v| 
        [
          k, 
          v.slug.buckets.map do |bucket| 
            {
              slug: bucket[:key], 
              name: bucket.name.buckets.first[:key], 
              job_offers_count: bucket.doc_count
            }
          end
        ]
      end.to_h

      @filter_counts = response.response.aggregations.filtered_job_offers.slice(*JobOffer::FACET_SLUGS.map{|slug| "filtered_#{slug}"}).values.map(&:to_a).flatten(1).to_h.slice(*JobOffer::FACET_SLUGS).values.map{|agg| agg.slug.buckets}.flatten.map{|bucket| [bucket[:key], bucket.doc_count]}.to_h

      @filters = @filters.map{|facet_name, facet_values| [facet_name, facet_values.map{|facet_value| facet_value[:job_offers_count] = @filter_counts[facet_value[:slug]]; facet_value}]}

      @job_offers = response.records

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
