require 'rufus-scheduler'
require 'rake'

require_relative './config/environment'

Rake.application.init
Rake.application.load_rakefile

scheduler = Rufus::Scheduler.new

scheduler.every '5m' do
  puts "Running rake task at #{Time.now}"
  Rake::Task['articles:remove_reported_articles'].reenable
  Rake::Task['articles:remove_reported_articles'].invoke
end

scheduler.join
