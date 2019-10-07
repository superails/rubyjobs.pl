class JobOfferPolicy < ApplicationPolicy
  def create?
    user.admin? && record.submitted? && record.unpublished?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
