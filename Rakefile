require 'dm-migrations'

Rake::TaskManager.record_task_metadata = true

task :default do
  Rake::application.options.show_tasks = :tasks
  Rake.application.options.show_task_pattern = //
  Rake.application.display_tasks_and_comments()
end

# Database stuff
namespace :db do
  desc 'Migrate database (data lost)'
  task :migrate do
    puts 'Migrating database'
    require_relative 'bootstrap.rb'
    DataMapper.auto_migrate!
  end

  desc 'Upgrade database (data kept)'
  task :upgrade do
    puts 'Upgrading database'
    require_relative 'bootstrap.rb'
    DataMapper.auto_upgrade!
  end

  desc 'Populate database'
  task :populate do
    puts 'Populating database'
    require_relative 'bootstrap.rb'

    class Application < Sinatra::Base
      role_normal = Role.create(
        :id => 0,
        :max_size => 5 * 1024 * 1024, # 5 MB
        :quota => 200 * 1024 * 1024 # 200 MB
      )

      role_pro = Role.create(
        :id => 1,
        :max_size => 20 * 1024 * 1024, # 20 MB
        :quota => 0 # unlimited
      )

      role_haxor = Role.create(
        :id => 9,
        :max_size => 0, # unlimited
        :quota => 0 # unlimited
      )

      User.create(
        :email => config['admin']['email'],
        :password => config['admin']['password'],
        :role => role_haxor
      )
    end
  end
end