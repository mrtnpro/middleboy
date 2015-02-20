namespace :deploy do
  def deploy(env)
    puts "Deploying to #{env}"
    system "TARGET=#{env} bundle exec middleman deploy"
  end

  task :staging do
    deploy :staging
  end

  task :production do
    deploy :production
  end
end