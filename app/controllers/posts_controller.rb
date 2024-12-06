class PostsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: %i[show edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :authorize_user!, only: %i[edit update destroy]

  def set_post
    @post = Post.find(params[:id])
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def authorize_user!
    unless @post.user == current_user
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
    @group = Group.find(params[:group_id])
    @post = @group.posts.find(params[:id])
  end

  def new
    @group = Group.find(params[:group_id])
    @post = @group.posts.build
  end

  def create
    Rails.logger.info "Create Action Params: #{params.inspect}"
    @group = Group.find(params[:group_id])
    @post = @group.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to group_post_path(@group, @post), notice: "Post created successfully!"
    else
      Rails.logger.error "Post Save Failed: #{@post.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @group = Group.find(params[:group_id])
    @post = @group.posts.find(params[:id])
  end

  def update
    @group = Group.find(params[:group_id])
    @post = @group.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to group_post_path(@group, @post), notice: "Post updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
    @post = @group.posts.find(params[:id])
    @post.destroy
    redirect_to group_path(@group), notice: "Post deleted successfully!", status: :see_other
  end

  private
    def post_params
      params.require(:post).permit(:post_name, :body)
    end
end
