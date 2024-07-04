require 'rails_helper'

RSpec.describe RegisterUserCmd do
  describe '.call' do
    subject { described_class.call(params: params) }

    context 'when email is not present' do
      let(:params) { { email: nil, password: 'password' } }

      it 'returns an error' do
        expect(subject.errors[:email]).to be_present
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end

      it 'does not return a user' do
        expect(subject.result).to be_nil
      end
    end

    context 'when password is not present' do
      let(:params) { { email: Faker::Internet.email, password: nil } }

      it 'returns an error' do
        expect(subject.errors[:password]).to be_present
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end

      it 'does not return a user' do
        expect(subject.result).to be_nil
      end
    end

    context 'when email is not in correct format' do
      let(:params) { { email: 'invalid_email', password: 'password' } }

      it 'returns an error' do
        expect(subject.errors[:base]).to be_present
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end

      it 'does not return a user' do
        expect(subject.result).to be_nil
      end
    end

    context 'when params are valid' do
      let(:params) { { email: Faker::Internet.email, password: 'password' } }

      it 'creates a user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'returns a user' do
        expect(subject.result).to be_a(User)
      end
    end
  end
end
