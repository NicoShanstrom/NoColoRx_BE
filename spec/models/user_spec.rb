require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user, email: 'TEST@EXAMPLE.COM', password: 'password123') }

  describe 'associations' do
    it { should have_many(:saved_prescriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
  end

  describe 'callbacks' do
    it 'downcases email before saving' do
      user.save
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'secure password' do
    it { should have_secure_password }
  end
end
