class TalksController < ApplicationController
  before_action :logged_in_user
  before_action :correct_number, only:[:show, :messages]

  def show
    @messages = @talk.messages
    @message = Message.new
  end

  def create
    @talk = Talk.new
    @talk.memberships.build(user_id: current_user.id)
    @talk.memberships.build(user_id: params[:member_id])
    @talk.save
    redirect_to @talk
  end

  def messages@,essage = Message.new(message_parames)
  @talk.touch
  if @message.save
    rediret_to @talk
  else
    @messages = @talk.messages
    render "show"
  end
end

praivate

def message_params
  params[:message].merge!({user_id: current_user.id, talk_id:@talk.id})
  params.require(:message).permit(:user_id, :talk_id, :content)
end

def correct_member
  @talk = current_user.talks.find_by(id:params[:id])
  redirect_to root_url if @talk.nil?
end

def correct_user
  @message = current_user.messages.find_by(id: params[:id])
  redirect_to root_url if @message.nil?
  end
end
