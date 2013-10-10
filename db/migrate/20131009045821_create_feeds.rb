class CreateFeeds < ActiveRecord::Migration
  def up
    create_table :feeds do |t|
      t.references :feedable, :polymorphic => true
      t.references :account

      t.timestamps
    end

    add_index :feeds, :feedable_id
    add_index :feeds, :account_id

    %w[comment vote visit afisha].each do |model|
      puts model.capitalize
      items = model.capitalize.constantize.where('user_id IS NOT NULL')
      bar = ProgressBar.new(items.count)
      items.each do |item|
        Feed.create(
          :feedable => item,
          :account => item.user.account,
          :created_at => item.created_at,
          :updated_at => item.updated_at
        )
        bar.increment!
      end
    end

    puts 'Invitation'
    items = Invitation.where('account_id IS NOT NULL')
    bar = ProgressBar.new(items.count)
    items.each do |item|
      Feed.create(
        :feedable => item,
        :account => item.account,
        :created_at => item.created_at,
        :updated_at => item.updated_at
      )
      bar.increment!
    end

  end

  def down
    remove_index :feeds, :feedable_id
    remove_index :feeds, :account_id
    drop_table :feeds
  end
end
