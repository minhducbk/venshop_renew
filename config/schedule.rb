every 10.minutes, RAILS_ENV: :development do
  rake "lib:tasks:vacuum"
  command "echo 'Finish run rake vacuum at #{Time.now.to_s}' >> output.txt"
end

every 10.minutes, RAILS_ENV: :development do
  command "sidekiq -c 1"
  command "echo 'Finish run sidekiq -c 1 #{Time.now.to_s}' >> output.txt"
end
