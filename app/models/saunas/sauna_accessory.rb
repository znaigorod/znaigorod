class SaunaAccessory < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :sheets, :sneakers, :bathrobes, :towels, :oils,
                  :ability_oils, :ability_own_alcohol, :alcohol_for_sale, :ware

  belongs_to :sauna
end

# == Schema Information
#
# Table name: sauna_accessories
#
#  id           :integer          not null, primary key
#  sauna_id     :integer
#  sheets       :integer
#  sneakers     :integer
#  bathrobes    :integer
#  towels       :integer
#  oils         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  ability_oils :integer
#  ware         :boolean
#

