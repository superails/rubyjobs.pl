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

  def short_salary
    salary.scan(/\d+/).reduce(salary) do |result, number| 
      human_number = ActionController::Base.helpers.number_to_human(number, format: '%n%u', units: {thousand: 'k'})
      result.gsub(number, human_number)
    end.gsub(/\s/,'')
  end

  def short_title
    translations = [
      [ 'Ruby on Rails', 'RoR']]
      
    translations.reduce(title) { |result, translation| result.gsub(/#{translation[0]}/i, translation[1]) }
  end
end
