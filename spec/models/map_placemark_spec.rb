require 'spec_helper'

describe MapPlacemark do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: map_placemarks
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  latitude           :float
#  longitude          :float
#  image_url          :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :string(255)
#  url                :string(255)
#  when               :string(255)
#  map_layer_id       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  kind               :string(255)
#  organization_title :string(255)
#  organization_url   :string(255)
#

