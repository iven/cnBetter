set :output, "/tmp/cnbetter.log"
job_type :padrino_rake, 'cd :path && padrino rake :task -e :environment --silent :output'

every 10.minutes do
  padrino_rake 'update_articles'
end

every 10.minutes do
  padrino_rake 'update_comments time=2'
end

every 20.minutes do
  padrino_rake 'update_comments time=4'
end

every 40.minutes do
  padrino_rake 'update_comments time=8'
end

