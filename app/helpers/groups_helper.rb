module GroupsHelper
  def cache_key_for_post(post)
    "post/#{post.id}/#{post.updated_at.to_i}"
  end

  def cache_key_for_post_section
    count = @posts.count
    max_updated_at = @posts.maximum(:updated_at)&.to_i
    "posts-section/group-#{@group.id}-#{count}-#{max_updated_at}"
  end
end
