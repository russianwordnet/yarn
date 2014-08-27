lock '3.2.1'

set :application, 'yarn'
set :repo_url, 'git://github.com/russianwordnet/yarn.git'
set :deploy_to, '/home/dmchk/yarn'

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml public/yarn.xml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
set :default_env, { lang: 'ru_RU.utf8', ruby_gc_malloc_limit: 90000000,
                    ld_preload: '/usr/lib64/libtcmalloc_minimal.so.4' }

set :bundle_bins, fetch(:bundle_bins, []).push('unicorn')
set :bundle_jobs, 4
set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }
set :bundle_binstubs, nil

set :rvm_ruby_version, '2.1.2'
set :rvm_roles, :app
set :rvm_type, :system

set :unicorn_conf, -> { shared_path.join('yarn.unicorn.rb') }
set :unicorn_pid, -> { shared_path.join('tmp/pids/yarn.pid') }

set :rails_env, :production

namespace :unicorn do

  desc 'Start Unicorn'
  task :start do
    on roles(:app), :in => :sequence do
      within current_path do
        with rack_env: fetch(:rails_env) do
          execute :bundle, "exec unicorn -c #{fetch(:unicorn_conf)} -D"
        end
      end
    end
  end

  desc 'Stop Unicorn'
  task :stop do
    on roles(:app), :in => :sequence do
      if test("[ -f #{fetch(:unicorn_pid)} ]")
        execute :kill, capture(:cat, fetch(:unicorn_pid))
      end
    end
  end

  desc 'Reload Unicorn without killing master process'
    task :reload do
      on roles(:app) do
        if test("[ -f #{fetch(:unicorn_pid)} ]")
          execute :kill, '-s USR2', capture(:cat, fetch(:unicorn_pid))
        else
          error 'Unicorn process not running'
        end
      end
    end

  desc 'Restart Unicorn'
  task :restart
  before :restart, :stop
  before :restart, :start

end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  before :publishing, 'squash:write_revision'
  after :publishing, :restart

end
