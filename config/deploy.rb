server 'motivationdashboard.r10.railsrumble.com', :app, :web, :db, :primary => true
set :deploy_via, :remote_cache

        require 'config/boot'
        require 'hoptoad_notifier/capistrano'
