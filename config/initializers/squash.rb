Squash::Ruby.configure api_host: ENV['SQUASH_HOST'],
                       api_key: ENV['SQUASH_KEY'],
                       disabled: !Rails.env.production?
