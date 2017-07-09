class UrlController < ApplicationController

  def create

  end

  def show

  end

  def url_params
    params.permit(:url)
  end

end
