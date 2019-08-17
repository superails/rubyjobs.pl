class JobDecorator < Draper::Decorator
  delegate_all

  def location_names
    locations.pluck(:name).join(', ')
  end
end
