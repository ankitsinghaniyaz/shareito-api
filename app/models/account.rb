class Account < ApplicationRecord


  enum type: {
    profile: 1,
    page: 2
  }

  enum source: {
    facebook: 1
  }

  enum status: {
    active: 1,
    expired: 2
  }

end
