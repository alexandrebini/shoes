class Admin::PalettesController < Admin::ApplicationController
  def index
    @palettes = Palette.all
  end

  def edit
    @palette = Palette.find(params[:id])
  end

  def update
    @palette = Palette.find(params[:id])

    if @palette.update(palette_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def new
    @palette = Palette.new
  end

  def create
    @palette = Palette.new(palette_params)

    if @palette.save
      redirect_to action: :index
    else
      render 'new'
    end
  end

  def destroy
    @palette = Palette.find(params[:id])
    @palette.destroy

    redirect_to action: :index
  end

  private

    def palette_params
      params.require(:palette).permit(:name, :hex, :slug, :mathers)
    end
end