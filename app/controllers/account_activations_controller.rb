# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      activate user
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end

  private

  def activate(user)
    user.activate
    log_in user
    flash[:success] = 'Account activated!'
    redirect_to user
  end
end
