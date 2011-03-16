class CommentsController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources
  actions :all, :only => [:create]

  def create
    create! do |format|
      format.js
    end
  end
end
