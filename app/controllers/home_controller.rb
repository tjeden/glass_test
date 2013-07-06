class HomeController < ApplicationController
  def index
  end

  def poke
    code = Connection.new(session[:token]).create_subscription
    redirect_to root_path, notice: "Message: #{code}"
  end
end
