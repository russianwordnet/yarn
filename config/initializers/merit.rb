# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongoid
  # config.orm = :active_record

  # Add application observers to get notifications when reputation changes.
  # config.add_observer 'MyObserverClassName'

  # Define :user_model_name. This model will be used to grand badge if no
  # `:to` option is given. Default is 'User'.
  # config.user_model_name = 'User'

  # Define :current_user_method. Similar to previous option. It will be used
  # to retrieve :user_model_name object if no `:to` option is given. Default
  # is "current_#{user_model_name.downcase}".
  # config.current_user_method = 'current_user'
end

Merit::Badge.create!(
  id: 0,
  name: 'github',
  description: 'GitHub, молодёжная социальная сеть.'
)

Merit::Badge.create!(
  id: 1,
  name: 'synsei',
  description: 'Синсей.'
)

Merit::Badge.create!(
  id: 2,
  name: 'first-definition',
  description: 'Добавил определение.'
)

Merit::Badge.create!(
  id: 3,
  name: 'first-example',
  description: 'Добавил пример употребления слова.'
)
