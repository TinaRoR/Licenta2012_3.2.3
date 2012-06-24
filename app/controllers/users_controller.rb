
class UsersController < ApplicationController
  before_filter :signed_in_user,    only: [:edit, :update, :index, :destroy]
  before_filter :correct_user,      only: [:edit, :update]
  before_filter :admin_user,        only: :destroy
  before_filter :already_signed_in, only: [:new, :create]
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create 
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Career Journal!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
   #@user = User.find(params[:id]) not needed anymore because of the filter correct_user
  end
  
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy unless User.find(params[:id]).admin?
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  
  private
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in." 
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def already_signed_in
      redirect_to root_path unless !signed_in?
    end
end
