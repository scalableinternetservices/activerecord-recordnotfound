module CommentsHelper
  def cache_key_for_comment(comment)
    "comment/#{comment.id}/#{comment.updated_at.to_i}"
  end

  def cache_key_for_comments_section
    count = @post.comments.count
    max_updated_at = @post.comments.maximum(:updated_at)&.to_i
    "comments-section/post-#{@post.id}-#{count}-#{max_updated_at}"
  end
end
