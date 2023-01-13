require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  it 'コメントがないと登録できない' do
    @comment.text = nil
    @comment.valid?
    expect(@comment.errors.full_messages).to include("Text can't be blank")
  end
end
