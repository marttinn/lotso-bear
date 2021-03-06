# -*- encoding : utf-8 -*-
module SessionsHelper

  def sign_in(user)
    #se crea un token
    remember_token = User.new_remember_token
    #se pasa a los cookies
    cookies.permanent[:remember_token] = remember_token
    #se pasa al usuario y DB
    user.update_attribute(:remember_token, User.digest(remember_token))
    #se actualiza el usuario
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end


  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil

  end



end
