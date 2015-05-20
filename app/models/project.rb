class Project < ActiveRecord::Base
  has_many :capacities
  has_many :accounts, through: :capacities

  def calculate_remaining_capacity
    update(used: capacities.pluck(:amount).sum)
  end
end
