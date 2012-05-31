class Eating < Organization
  attr_accessible :cuisine
  alias_attribute :eating_categories, :organization_categories

  def self.or_facets
    %w[eating_categories]
  end

  def self.facets
    %w[eating_categories payment cuisine feature offer]
  end

  add_sunspot_configuration
end

# == Schema Information
#
# Table name: organizations
#
#  id                      :integer         not null, primary key
#  title                   :text
#  organization_categories :text
#  payment                 :text
#  cuisine                 :text
#  feature                 :text
#  site                    :text
#  email                   :text
#  description             :text
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  phone                   :text
#  offer                   :text
#  type                    :string(255)
#  vfs_path                :string(255)
#

