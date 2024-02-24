class StaticPagesController < ApplicationController
  before_action :require_user_authentication

  def index; end
end
