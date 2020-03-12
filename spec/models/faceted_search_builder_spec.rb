require 'rails_helper'

RSpec.describe FacetedSearchBuilder, type: :model do
  describe '#call' do
    it 'builds search with all facets and categories associated with published jobs' do
      job1 = create(:job_offer, state: 'published', city_names: 'Warszawa, Białystok', remote: '0', 
                    title: 'Junior Dev')
      job2 = create(:job_offer, state: 'published', city_names: 'Warszawa', remote: '0', 
                    title: 'RoR Dev')
      job3 = create(:job_offer, state: 'submitted', city_names: 'Warszawa', remote: '1', 
                    title: 'Senior Dev')

      JobOffer.all.each {|job_offer| FacetGenerator.new(job_offer).call }

      js_category = create(:facet_category, name: 'Framework JS', slug: 'js-framework', rank: 20)
      lang_category = create(:facet_category, name: 'Język programowania', slug: 'programming-language', rank: 10)
      devops_category = create(:facet_category, name: 'Technologie Devops', slug: 'devops', rank: 0)

      job1.company.facets << create(:facet, name: 'VueJS', slug: 'vuejs', facet_category_id: js_category.id)
      job1.company.facets << create(:facet, name: 'Elixir', slug: 'elixir', facet_category_id: lang_category.id)
      job2.company.facets << create(:facet, name: 'Docker', slug: 'docker', facet_category_id: devops_category.id)
      job2.company.facets << create(:facet, name: 'VueJS', slug: 'vuejs', facet_category_id: js_category.id)

      search_params = {experience: ['junior'], location: ['bialystok']}

      search = FacetedSearchBuilder.new(search_params).call 

      expect(search.keys).to eq %w(location experience js-framework programming-language devops)

      expect(search.values.flatten.map{|facet| [facet.name, facet.slug, facet.job_offers_count]}).to eq [
        ['Warszawa', 'warszawa', 1],
        ['Białystok', 'bialystok', 1],
        ['Junior', 'junior', 1],
        ['Mid', 'mid', 0],
        ['VueJS', 'vuejs', 1],
        ['Elixir', 'elixir', 1],
        ['Docker', 'docker', 0]
      ]
    end
  end
end
