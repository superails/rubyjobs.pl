set :chronic_options, hours24: true

every 1.hour do
  runner "JobOfferExpirationChecker.new.call"
end
