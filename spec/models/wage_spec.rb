require 'rails_helper'

RSpec.describe Wage, type: :model do
  before do
    @wage = FactoryBot.build(:wage)
  end

  it '終了時間がないと登録できない' do
    @wage.end_time = nil
    @wage.valid?
    expect(@wage.errors.full_messages).to include("End time can't be blank")
  end
end
