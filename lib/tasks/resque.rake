# resque.rake
require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
  # Place One time Job Over Here
  # Example
  # Resque.enqueue_in(10.seconds, OrderCharge, :user_id => 1)
  ENV['QUEUE'] = '*'
  ENV['COUNT'] = '5'
  ENV['VERBOSE'] = '1'
  Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }
  Resque.enqueue(UpdateArticleList)
  Resque.enqueue(UpdateComments)
end

