set :chronic_options, hours24: true

every 1.hour do
  runner "JobOffersRefresher.call"
end
