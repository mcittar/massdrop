class UrlController < ApplicationController

  def create
    @url = Url.new(url_params)

    if @url.save
      HardWorker.perform_async(@url.id)
      render json: { id: @url.id }, status: 200
    else
      render json: @url.errors.full_messages, status: 422
    end

  end

  def show
    @url = Url.find_by_id(params[:id])

    if @url
      render 'url/show.json.jbuilder'
    else
      render json: { message: "no job found" }, status: 200
    end

  end

  def url_params
    params.permit(:url, :status)
  end

end
