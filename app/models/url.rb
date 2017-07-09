# == Schema Information
#
# Table name: urls
#
#  id         :integer          not null, primary key
#  url        :string           not null
#  status     :boolean          not null
#  html       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Url < ApplicationRecord
  validates :url, presence: true

  validates_inclusion_of :status, in: [true, false]
end
