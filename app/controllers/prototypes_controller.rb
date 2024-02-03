class PrototypesController < ApplicationController
  before_action :authenticate_user!,except: [:index, :show]
  before_action :move_to_index, except: [:index, :show]
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]

  def index
    @prototypes = Prototype.all
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @prototype = Prototype.new
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    
    unless user_signed_in? && current_user == @prototype.user
      redirect_to action: :index
    end
  end

  def update
    if @prototype.update(prototype_params)
        redirect_to prototype_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless user_signed_in? && current_user == @prototype.user
      redirect_to action: :index
    end
    @prototype.destroy
      redirect_to root_path
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  
  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

end
