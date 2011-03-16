class MessagesController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources
  actions :all, :except => [ :edit, :update]

  def create
    @message = current_user.sent_messages.new(params[:message])
    create!(:location => messages_path(:mailbox => "sent"))
  end

  def show
    resource
    @message.read! if current_user == @message.recipient
  end

  def destroy
    @message = Message.where(["sender_id = :user OR recipient_id = :user", {:user => current_user}]).find(params[:id])
    @message.mark_deleted(current_user)
    redirect_to collection_path(:mailbox => params[:mailbox])
  end
  protected

  def resource
    @message ||= Message.where(["sender_id = :user OR recipient_id = :user", {:user => current_user}]).find(params[:id])
  end

  def collection
    @messages ||= if params[:mailbox] == "sent"
      @current_user.sent_messages.paginate(:page => params[:page])
    else
      @current_user.recieved_messages.paginate(:page => params[:page])
    end
  end

end
