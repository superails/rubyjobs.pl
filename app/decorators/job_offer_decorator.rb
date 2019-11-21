class JobOfferDecorator < Draper::Decorator
  delegate_all

  def location_names
    locations.map(&:name).sort_by{|name| name == 'Zdalnie' ? '' : name}.join(', ')
  end

  def time_since_publication
    return "NEW" if published_at.nil? || Time.zone.now - published_at <= 24.hours 
    return "#{((Time.zone.now - published_at) / (24 * 60 * 60)).to_i}d" if Time.zone.now - published_at <= 30.days

    "#{((Time.zone.now - published_at) / (30 * 24 * 60 * 60)).to_i}m"
  end
end
