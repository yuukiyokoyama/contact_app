module MicropostDecorator
  def decorated_content
    if reply?
      link_to("@#{in_reply_to.name}", in_reply_to) + " " + content_object.content
    else
      content
    end
  end
end