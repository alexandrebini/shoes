class Admin::CategoriesController < Admin::ApplicationController
  def index
    @categories = Category.all
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to action: :index
    else
      render 'new'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    redirect_to action: :index
  end

  private

    def category_params
      params.require(:category).permit(:name, :meta_description, :matchers, :slug)
    end
end