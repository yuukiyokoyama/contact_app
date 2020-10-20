class MembershipsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: destroy

  def create
    @talk = Talk.find(params[:talk_id])
    params[:guest_users].each do |guest_user|
      if @talk.member?(guest_user)

      else
        @talk.add_member(guest_usr)
      end
    end
  end

  def destroy
    @membership.destroy
    flash[:success] = "Lefe the talk"
    redirect_back(fallback_locatiion: root_url)
  end

  pribate

  def correct_user@membership =current_user.memberships.find_by(id: params[:id])
    redirect_to root_url if @membership.nil?
  end
end
