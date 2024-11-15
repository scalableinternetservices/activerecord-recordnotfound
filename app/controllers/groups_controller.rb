class GroupsController < ApplicationController
  before_action :require_login

  def index
    if params[:search]
      @groups = Group.where("group_name ILIKE ?", "%#{params[:search]}%")
    else
      @groups = Group.all
    end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.admin_id = @current_user.id

    if @group.save
      current_user.join_group(@group.id)
      redirect_to @group
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      redirect_to(@group)
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @group = Group.find(params[:id])

    User.where('group_ids @> ?', "{#{@group.id}}").find_each do |user|
      user.group_ids.delete(@group.id)
      user.save
    end

    @group.destroy()

    redirect_to(groups_path, status: :see_other)
  end


  def join_group

    @group = Group.find(params[:id])

    if current_user.join_group(@group.id)
      redirect_to @group, notice: "You have successfully joined the group!"
    else
      redirect_to @group, alert: "There was an error joining the group."
    end
  end

  def leave_group

    @group = Group.find(params[:id])

    if current_user.leave_group(@group.id)
      redirect_to @group, notice: "You have successfully left the group!"
    else
      redirect_to @group, alert: "There was an error leaving the group."
    end
  end

  private
    def group_params
      params.require(:group).permit(:group_name)
    end
end

