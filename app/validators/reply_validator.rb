class ReplyValidator < ActiveModel::Validator
  def validate(record)
    if record.in_reply_to.nil? || !record.in_reply_to.activated # 1,2
      record.errors.add('content', "User ID does not exist or account is anactivated.")
    elsif record.in_reply_to.reply_name != record.content_object.reply_name # 3
      record.errors.add('content', "Reply Name is invalid.")
    elsif record.in_reply_to == record.user # 4
      record.errors.add('content', "can not reply to myself.")
    end
  end
end