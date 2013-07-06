class HomeController < ApplicationController
  def index
  end

  def poke
    code = Connection.new(session[:token]).text("Hello")
    redirect_to root_path, notice: "Message: #{code}"
  end
end
