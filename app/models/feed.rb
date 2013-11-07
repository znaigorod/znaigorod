class Feed < ActiveRecord::Base
  attr_accessible :feedable, :account, :created_at, :updated_at
  belongs_to :feedable, :polymorphic => true
  belongs_to :account

  scope :discount_or_member,  -> {where("feedable_type = 'Member' OR feedable_type = 'Discount'")}

  def self.feeds_for_presenter(searcher_params)
    if searcher_params[:feedable_type] == 'Discount'
      searcher_params.delete(:feedable_type)
      self.discount_or_member.where(searcher_params).includes(:feedable).order('created_at DESC')
    else
      self.where(searcher_params).includes(:feedable).order('created_at DESC')
    end
  end

end

# == Schema Information
#
# Table name: feeds
#
#  id            :integer          not null, primary key
#  feedable_id   :integer
#  feedable_type :string(255)
#  account_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

