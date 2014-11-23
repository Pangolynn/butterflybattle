class HomeController < ApplicationController
  def index

  end

  def get_play
    @color = params[:color]
      render template: "home/play"


  end

  def post_play
      render template: "home/play"

  end


end
