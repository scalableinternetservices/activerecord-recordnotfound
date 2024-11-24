class CommentsController < ApplicationController
  before_action :set_group_and_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to group_post_path(@group, @post), notice: "Comment added successfully!"
    else
      redirect_to group_post_path(@group, @post), alert: "Failed to add comment."
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to group_post_path(@group, @post), notice: "Comment deleted successfully!"
    else
      redirect_to group_post_path(@group, @post), alert: "You are not authorized to delete this comment."
    end
  end

  private

  def set_group_and_post
    @group = Group.find(params[:group_id])
    @post = @group.posts.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

