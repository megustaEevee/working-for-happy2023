class WorksController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :find_user, only: [:index, :create]
  before_action :today, only: [:index, :show, :create]
  before_action :find_work, :pay_calc, only: :show

  def index
    @work = Work.new

    @work_last = Work.order(id: :DESC).find_by(user_id: current_user.id) if user_signed_in?
  end

  def show
    @wage = Wage.new

    @comment = Comment.new
    @comments = @work.comments
  end

  def create
    @work = Work.new(work_params)
    if @work.save
      redirect_to @work
    else
      render 'index'
    end
  end

  private

  def find_user
    @users = User.all
  end

  def work_params
    params.require(:work).permit(:start_time).merge(user_id: current_user.id)
  end

  def today
    @time = Time.now
  end

  def find_work
    @work = Work.find(params[:id])
  end

  def pay_calc
    @mini_wage = 1012 # 横浜市最低賃金（令和2年10月1日）
    @fifty = @mini_wage * 1.5
    @twenty_five = @mini_wage * 1.25

    @time_hour = if @time.hour < @work.start_time
                  @time.hour + 24 # 連続して24時間以上の勤務はしないと仮定します
                else
                  @time.hour
                end

    @end_time = @time_hour - @work.start_time # 一回の労働時間の合計

    if @work.start_time <= 5 # 夜間勤務時刻を22時から29時とします
      @start_time = @work.start_time + 24
      @time_hour += 24
    else
      @start_time = @work.start_time
      @time_hour
    end

    @l_time = if @start_time >= 22 && @time_hour <= 29 # 深夜勤務時間の計算
                @time_hour - @start_time
              elsif @start_time >= 22 && @time_hour > 29
                29 - @start_time
              elsif @start_time < 22 && @time_hour > 29
                7
              elsif @start_time < 22 && @time_hour >= 22 && @time_hour <= 29
                @time_hour - 22
              else
                0
              end

    @o_time = if @end_time > 8 # 一日の超過勤務時間の計算
                @end_time - 8
              else
                0
              end

    if @o_time != 0 && @l_time != 0 # 重複分の計算
      if @start_time <= 14 # 深夜時間が全て超過勤務の場合
        @l_pay = @l_time * @fifty
        @o_pay = (@o_time - @l_time) * @twenty_five
        @n_pay = 8 * @mini_wage
        @paying = @n_pay + @o_pay + @l_pay
      elsif @start_time > 14 && @start_time < 21 # 深夜の途中から超過勤務の場合
        @d_time = 21 - @start_time
        if @d_time >= @o_time # 最大でも6時間
          @d_pay = @o_time * @fifty
          @l_pay = (@l_time - @o_time) * @twenty_five
          @o_pay = 0
          @n_pay = (@end_time - @l_time) * @mini_wage
        else
          @d_pay = @d_time * @fifty
          @l_pay = (@l_time - @d_time) * @twenty_five
          @o_pay = (@o_time - @d_time) * @twenty_five
          @n_pay = (@end_time + @d_time - @l_time - @o_time) * @mini_wage
        end
        @paying = @n_pay + @o_pay + @l_pay + @d_pay
      else
        @ol_pay = (@o_time + @l_time) * @twenty_five
        @n_pay = (8 - @l_time) * @mini_wage
        @paying = @n_pay + @ol_pay
      end
    elsif @o_time != 0
      @n_pay = 8 * @mini_wage
      @o_pay = @o_time * @twenty_five
      @paying = @n_pay + @o_pay
    elsif @l_time != 0
      @l_pay = @l_time * @twenty_five
      @n_pay = (@end_time - @l_time) * @mini_wage
      @paying = @n_pay + @l_pay
    else
      @paying = @end_time * @mini_wage
    end
  end
end
