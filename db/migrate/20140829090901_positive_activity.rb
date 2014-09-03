class PositiveActivity < ActiveRecord::Migration
  def up
    add_column :organizations, :positive_activity_date, :datetime

    without_activity = []
    Organization.where(status: :client).each do |org|
      activity = org.activities.where(state: :completed)
      if activity.present?
        org.update_attribute(:positive_activity_date, activity.first.activity_at)
      else
        without_activity << org
      end
    end

    refresh_status = []
    without_activity.each do |org|
      if org.primary_organization.present?
        org.update_attribute(:positive_activity_date, org.primary_organization.positive_activity_date)
      else
        refresh_status << org
      end
    end

    refresh_status.each do |org|
      org.update_attribute(:status, :fresh)
    end

  end

  def down
    remove_column :organizations, :positive_activity_date
  end
end
