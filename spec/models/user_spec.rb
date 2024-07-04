# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:access_tokens) }
    it { is_expected.to have_many(:videos) }
  end

  describe 'validations' do
    subject { create(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }

    it 'returns an error if email is incorrect format' do
      user = build(:user, email: 'invalid_email')
      user.valid?
      expect(user.errors[:email]).to be_present
    end

    it 'returns valid if email is correct format' do
      user = build(:user, email: 'valid@example.com')
      user.valid?
      expect(user.errors[:email]).to be_empty
    end
  end

  describe 'class methods' do
    describe '.authenticate' do
      let(:user) { create(:user) }

      it 'returns user if email and password are correct' do
        expect(User.authenticate(user.email, user.password)).to eq(user)
      end

      it 'returns nil if email is incorrect' do
        expect(User.authenticate('wrong_email', user.password)).to be_nil
      end

      it 'returns nil if password is incorrect' do
        expect(User.authenticate(user.email, 'wrong_password')).to be_nil
      end
    end
  end
end
