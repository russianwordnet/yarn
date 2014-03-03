# encoding: utf-8

namespace :yarn do
  desc 'Create an user'
  task :useradd => :environment do
    raise 'Missing ENV["name"]' unless ENV['name']
    ActiveRecord::Base.connection.reset_pk_sequence! User.table_name
    user = User.create! name: ENV['name'], provider: ENV['provider'], uid: ENV['uid']
    puts 'User was successfully created with ID=%d.' % user.id
  end

  desc 'Delete an user'
  task :userdel => :environment do
    raise 'Missing ENV["id"]' unless ENV['id']
    user = User.destroy(ENV['id'])
    ActiveRecord::Base.connection.reset_pk_sequence! User.table_name
    puts 'User "%s" was deleted successfully.' % user.name
  end
end
