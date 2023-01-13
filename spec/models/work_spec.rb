require 'rails_helper'

RSpec.describe Work, type: :model do
  before do
    @work = FactoryBot.build(:work)
  end

  it '開始時間がないと登録できない' do
    @work.start_time = nil
    @work.valid?
    expect(@work.errors.full_messages).to include("Start time can't be blank")
  end
end
