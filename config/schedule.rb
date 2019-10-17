every 1.hour do
  runner "JobOfferExpirationChecker.new.call"
end
