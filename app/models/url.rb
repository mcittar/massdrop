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
  validates :id, :url, uniqueness: true

  validates_inclusion_of :status, in: [true, false]

  before_validation :smart_add_url_protocol

  private

  def smart_add_url_protocol
    if self.url
      unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
        self.url = "https://#{self.url}"
      end
    end
  end
end
