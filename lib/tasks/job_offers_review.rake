namespace :job_offers_review do
  desc "Generates job offers review grouped by locations"
  task locations: :environment do
    Location.
      includes(:job_offers).
      where(job_offers: {state: 'published'}).
      sort_by{|location| location.name == 'Zdalnie' ? -Float::INFINITY : -location.job_offers.published.count}.
      each do |location|
        puts "[#{location.name}]"
        location.job_offers.published.decorate.sort_by{|job_offer| job_offer.salary.to_i}.each do |job_offer|
          begin
            url = Rails.application.routes.url_helpers.job_offer_url(job_offer, host: 'https://rubyjobs.pl')
            bitly_url = RestClient.get( "https://api-ssl.bitly.com/v3/shorten?longUrl=#{CGI.escape(url)}&access_token=#{Rails.application.credentials.bitly[:access_token]}&format=txt")
            puts "#{job_offer.short_title}; #{job_offer.short_salary}; #{job_offer.company.name}; #{bitly_url.body.chomp}"
          rescue RestClient::Forbidden
            sleep(5)
            retry
          end
        end
        puts
      end
  end
end
