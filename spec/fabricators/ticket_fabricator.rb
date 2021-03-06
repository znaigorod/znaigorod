# == Schema Information
#
# Table name: tickets
#
#  id                 :integer          not null, primary key
#  afisha_id          :integer
#  number             :integer
#  original_price     :float
#  price              :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  description        :text
#  stale_at           :datetime
#  organization_price :float
#  email_addresses    :text
#  undertow           :integer
#  state              :string(255)
#  payment_system     :string(255)
#  short_description  :string(255)
#

Fabricator :ticket do
  number 10
  original_price 1000
  price 500
  description 'some concert'
  affiche { Fabricate :exhibition }
  stale_at { Time.zone.now + 2.days }
end
