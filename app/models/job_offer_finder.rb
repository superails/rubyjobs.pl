class JobOfferFinder
  attr_reader :search_params, :user

  def initialize(search_params, user)
    @user = user
    @search_params = search_params
  end

  def call
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
              state: user.admin? ? ['published', 'submitted'] : ['published']
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
                filter: {
                  terms: {
                    state: user.admin? ? ['published', 'submitted'] : ['published']
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
                      end << {
                        terms: {
                          state: user.admin? ? ['published', 'submitted'] : ['published']
                        }
                      }
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


      @filters = response.response.aggregations.all_job_offers.slice(*JobOffer::FACET_SLUGS).map{|k,v| v}.map(&:to_a).flatten(1).to_h.slice(*JobOffer::FACET_SLUGS).map do |k,v| 
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

      [@job_offers, @filters]
  end
end
