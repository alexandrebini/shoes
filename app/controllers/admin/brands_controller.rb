class Admin::BrandsController < Admin::ApplicationController
  def index
    @brands = Brand.all
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])

    if @brand.update(brand_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      redirect_to action: :index
    else
      render 'new'
    end
  end

  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy

    redirect_to action: :index
  end

  private

    def brand_params
      params.require(:brand).permit(:name, :url, :start_url, :verification_matcher,
        :meta_description, :logo)
    end
end