namespace :job_offers_review do
  desc "Generates job offers review grouped by locations"
  task locations: :environment do
    Location.
      includes(:job_offers).
      where(job_offers: {state: 'published'}).
      sort_by{|location| location.name == 'Zdalnie' ? -Float::INFINITY : -location.job_offers.count}.
      each do |location|
        puts "[#{location.name}]"
        location.job_offers.published.each do |job_offer|
          url = Rails.application.routes.url_helpers.job_offer_url(job_offer, host: 'https://rubyjobs.pl')
          bitly_url = RestClient.get( "https://api-ssl.bitly.com/v3/shorten?longUrl=#{CGI.escape(url)}&access_token=#{Rails.application.credentials.bitly[:access_token]}&format=txt")
          puts "#{job_offer.title}; #{job_offer.salary}; #{bitly_url.body.chomp}"
        end
        puts
      end
  end
end
