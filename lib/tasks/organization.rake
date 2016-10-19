# encoding: utf-8

require 'progress_bar'

namespace :organization do

  desc 'Delete old tariffs from organization'
  task :old_tariffs => :environment do
    organization_tariffs = OrganizationTariff.all
    bar = ProgressBar.new(organization_tariffs.count)
    count_deleted = 0
    organization_tariffs.each do |o_t|
      if o_t.left_days < 0
        MyMailer.mail_tariff_expired(o_t).deliver
        o_t.destroy
        count_deleted+=1
      end
      bar.increment!
    end
    p "Было удалено #{count_deleted} старых тарифов!" if count_deleted > 0
  end

  desc 'conversion schedules to full_schedules'
  task :to_full_schedules => :environment do
    days_array = %w(ololo monday tuesday wednesday thursday friday saturday sunday)

    bar = ProgressBar.new(Organization.count)
    Organization.all.each do |organization|
      organization.full_schedules.map(&:destroy)
      workdays = organization.schedules.where(:holiday => false)
      modes = workdays.group_by{|e| [e.from, e.to]}.keys

      modes.each do |mode|
        fs = organization.full_schedules.create(:from => mode[0], :to => mode[1])
        (1..7).each { |d| fs.update_attribute(days_array[d], false) }
        fs.free = false
        workdays.where(:from => mode[0], :to => mode[1]).each do |work|
          fs.update_attribute(days_array[work.day], true)
        end
      end

      holidays = organization.schedules.where(:holiday => true)

      if holidays.count > 0
        full_holidays = organization.full_schedules.create(:from => Time.new(2000, 1, 1), :to => Time.new(2000, 1, 1))
        (1..7).each { |d| full_holidays.update_attribute(days_array[d], false) }
        full_holidays.free = true
        holidays.each do |holi|
          full_holidays.update_attribute(days_array[holi.day], true)
        end
      end
      bar.increment!
    end
  end


  desc 'Upload posters to vkontakte'
  task :posters_to_vk => :environment do
    puts 'Upload organization posters to vkontakte'
    organizations = Organization.where('logotype_url is not null') - Organization.where(logotype_url: "")
    bar = ProgressBar.new(organizations.count)
    organizations.each do |organization|
      organization.upload_poster_to_vk
      bar.increment!
    end
  end

  desc 'Обновление positive_activity_date у организаций'
  task :update_positive_activity_date => :environment do
    organizations = Organization.search { with :status, [:client_standart, :client_premium] }.results
    bar = ProgressBar.new(organizations.count)
    organizations.each do |organization|
      if organization.positive_activity_date && (organization.positive_activity_date < Time.zone.now - 7.days)
        organization.update_attribute :positive_activity_date, Time.zone.now
      end

      bar.increment!
    end
  end

  desc 'Обновление positive_activity_date у организаций с пакетом эконом'
  task :update_positive_activity_date_economy => :environment do
    organizations = Organization.search { with :status, [:client_economy] }.results
    bar = ProgressBar.new(organizations.count)
    organizations.each do |organization|
      unless organization.positive_activity_date
        organization.update_attribute :positive_activity_date, Time.zone.now
      else
        if organization.positive_activity_date < Time.zone.now - 1.month
          organization.update_attribute :positive_activity_date, Time.zone.now
        end
      end

      bar.increment!
    end
  end
end
