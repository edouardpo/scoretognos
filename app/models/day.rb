class Day < ActiveRecord::Base
  belongs_to :championship
  has_many :fixtures

  validates :championship, :date, :status, :name, presence: :true
  module Status
    REGULAR = 'regular'
    FINALS = 'finals'

    ALL = [REGULAR, FINALS]
  end
  STATUS = %w(regular finals)

  validates :status, inclusion: { in: Status::ALL  }
end
