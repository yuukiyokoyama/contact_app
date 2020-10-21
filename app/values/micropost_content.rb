class MicropostContent
  
  REPLY_CONTENT_REGEX = /\A(@(?<user_id>\d{1,})-(?<user_name>[^\s]+)\s)?/i
  
  def initialize(micropost_content)
    @micropost_content = micropost_content
  end
  
  def reply_name
    m = @micropost_content.match(REPLY_CONTENT_REGEX)
    ReplyName.new(m[:user_id], m[:user_name])
  end
  
  def content
    @micropost_content.sub(REPLY_CONTENT_REGEX, '')
  end
  
  def reply?
    reply_name.valid?
  end
  
  def blank?
    content.blank?
  end
end