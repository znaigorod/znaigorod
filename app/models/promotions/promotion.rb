class Promotion < ActiveRecord::Base
  alias_attribute :to_s, :url

  attr_accessible :url

  has_many :promotion_places, :dependent => :destroy, :order => :position

  scope :ordered, -> { order :url }

  validates :url, :presence => true, :uniqueness => true

  after_create :create_promotion_places

  private

  def create_promotion_places
    6.times do |i|
      promotion_places.create
    end
  end
end

# == Schema Information
#
# Table name: promotions
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

