set :chronic_options, hours24: true

every 1.hour do
  runner "JobOffersRefresher.call"
end

every 5.minutes do
  rake "pghero:capture_query_stats"
end
