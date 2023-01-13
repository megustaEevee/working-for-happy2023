class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @time = Time.now

    @user = User.find(params[:id])
    @work = Work.order(id: :DESC).find_by(user_id: @user.id)
    @wage = @user.wages.find_by(work_id: @work.id) if @user.wages != []

    @wages = Wage.order(id: :DESC).where(user_id: @user.id)
    @comments = Comment.order(id: :DESC).where(user_id: @user.id)
  end
end