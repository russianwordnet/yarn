class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def method_missing(provider)
    return redirect_to root_url if user_signed_in?

    omniauth = env['omniauth.auth']

    if user = User.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'].to_s)
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: omniauth['provider'])
      sign_in_and_redirect(:user, user)
    else
      name = omniauth['info']['name']
      unless name && name.valid_encoding?
        name = omniauth['info']['nickname']
      end
      user = User.new(name: name, provider: omniauth['provider'], uid: omniauth['uid'])
      if user.save
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to root_url
      end
    end
  end
end
