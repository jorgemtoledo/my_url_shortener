class LinkController < ApplicationController
  before_action :find_url, ond:[:show, :shortened]
  skip_before_action :verify_authenticity_token

  def index
    @url = Link.all
  end

  def show
    redirect_to @url.sanitize_url
  end

  def create
    puts "teste create"
    @url = Link.new
    @url.url = params[:url]
    @url.sanitize
    if @url.new_url?
      if @url.save
        redirect_to link_path(@url.slug)
      else
        flash[:error] = "Erro ao criar"
        render 'index'
      end
    else
      flash[:notice] = "Já cadastrado"
      redirect_to link_path(@url.find_duplicate.slug)
    end
  end

  def shortened
    @url = Link.find_by(slug: params[:slug])
    # host = request.host_with_port
    host = request.host_with_port
    @original_url = @url.sanitize_url
    @slug = host + '/' + @url.slug
  end

  def fetch_original_url 
    fetch_url = Link.find_by(slug: params[:slug])
    redirect_to fetch_url.sanitize_url
  end

  private
  def find_url
    @url = Link.find_by(slug: params[:slug])
  end

  def url_params
    params.require(:url).permit(:url)
  end
end