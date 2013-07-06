class HomeController < ApplicationController
  def index
  end

  def poke
    Connection.new.test(session[:token])
    redirect_to root_path
  end
end
