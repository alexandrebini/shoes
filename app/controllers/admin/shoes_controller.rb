class Admin::ShoesController < Admin::ApplicationController
  def index
    @shoes = Shoe.all
  end

  def edit
    @shoe = Shoe.find(params[:id])
  end

  def update
    @shoe = Shoe.find(params[:id])

    if @shoe.update(shoe_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def new
    @shoe = Shoe.new
  end

  def create
    @shoe = Shoe.new(shoe_params)

    if @shoe.save
      redirect_to action: :index
    else
      render 'new'
    end
  end

  def destroy
    @shoe = Shoe.find(params[:id])
    @shoe.destroy

    redirect_to action: :index
  end

  private

    def shoe_params
      params.require(:shoe).permit(:name, :brand, :category, :slug, :source_url, :description, :colors)
    end
end