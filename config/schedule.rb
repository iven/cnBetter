set :output, "/tmp/cnbetter.log"

every 10.minutes do
  rake 'update_articles'
end

every 10.minutes do
  rake 'update_comments time=2'
end

every 20.minutes do
  rake 'update_comments time=4'
end

every 40.minutes do
  rake 'update_comments time=8'
end

