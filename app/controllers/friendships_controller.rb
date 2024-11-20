class FriendshipsController < ApplicationController
  before_action :require_login
  
  def create
    recipient = User.find(params[:recipient_id])
    
    if current_user.send_friend_request(recipient)
      redirect_back_or_to root_path, notice: 'Friend request sent!'
    else
      redirect_back_or_to root_path, alert: 'Unable to send friend request.'
    end
  end

  def accept
    if current_user.accept_friend_request(params[:id].to_i)
      redirect_back_or_to root_path, notice: 'Friend request accepted!'
    else
      redirect_back_or_to root_path, alert: 'Unable to accept friend request.'
    end
  end

  def reject
    if current_user.reject_friend_request(params[:id].to_i)
      redirect_back_or_to root_path, notice: 'Friend request rejected.'
    else
      redirect_back_or_to root_path, alert: 'Unable to reject friend request.'
    end
  end

  def destroy
    if current_user.remove_friend(params[:id].to_i)
      redirect_back_or_to root_path, notice: 'Friend removed.'
    else
      redirect_back_or_to root_path, alert: 'Unable to remove friend.'
    end
  end
end 