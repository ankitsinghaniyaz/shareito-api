class Account < ApplicationRecord

  belongs_to                :team

  validates_presence_of     :team
  validates_presence_of     :name
  validates_presence_of     :source_id
  validates_presence_of     :image
  validates_presence_of     :source
  validates_presence_of     :type

  enum type: {
    profile: 1,
    page: 2,
    community: 3,
  }

  enum source: {
    facebook: 1
  }

  enum status: {
    active: 1,
    expired: 2
  }

end
