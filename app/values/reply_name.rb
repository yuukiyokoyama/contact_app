class ReplyName
  
  include Comparable
  attr_reader :user_id
  
  def initialize(user_id, user_name)
    @user_id = user_id
    @user_name = user_name
  end
  
  def <=>(other)
    to_s <=> other.to_s
  end
  
  def to_s
    "@#{user_id}-#{@user_name.gsub(/\s/, '-')}"
  end
  
  def valid?
    !!user_id && !!@user_name
  end
end