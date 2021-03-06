class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :title
      t.string :url
      t.attachment :image
      t.integer :width
      t.integer :height
      t.timestamps
    end
  end
end
