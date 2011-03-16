class UsersController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources
  actions :all ,:only => [:show]

  
end
