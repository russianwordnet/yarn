Squash::Ruby.configure api_host: Rails.configuration.local['squash_host'],
                       api_key: Rails.configuration.local['squash_key'],
                       disabled: !Rails.env.production?
