require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelperHelper. For example:
#
# describe ApplicationHelperHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe '#truncate_description' do
    context 'when param length has not been set' do
      subject { helper.truncate_description(description) }

      context 'when description is less than 100 characters' do
        let(:description) { 'a' * 50 }

        it { is_expected.to eq(description) }
      end

      context 'when description is more than 100 characters' do
        let(:description) { 'a' * 150 }

        it { is_expected.to eq("#{'a' * 100}...") }
      end
    end

    context 'when param length has been set' do
      subject { helper.truncate_description(description, length: length) }

      let(:length) { 50 }

      context 'when description is less than 50 characters' do
        let(:description) { 'a' * 25 }

        it { is_expected.to eq(description) }
      end

      context 'when description is more than 50 characters' do
        let(:description) { 'a' * 75 }

        it { is_expected.to eq("#{'a' * length}...") }
      end
    end
  end

  describe '#palindrome?' do
    subject { helper.palindrome?(args) }

    context 'when args is nil' do
      let(:args) { nil }

      it { is_expected.to be(false) }
    end

    context 'when args is not a string' do
      let(:args) { 123 }

      it { is_expected.to be(false) }
    end

    context 'when args is an empty string' do
      let(:args) { '' }

      it { is_expected.to be(false) }
    end

    context 'when args is not a palindrome' do
      let(:args) { 'thach' }

      it { is_expected.to be(false) }
    end

    context 'when args is a case-sensitive palindrome' do
      let(:args) { 'Refer' }

      it { is_expected.to be(true) }
    end

    context 'when args is a case-insensitive palindrome' do
      let(:args) { 'malayalam' }

      it { is_expected.to be(true) }
    end

    context 'when args is a palindrome with special characters' do
      let(:args) { 'ma.la!ya   lam' }

      it { is_expected.to be(true) }
    end
  end

  describe '#rotate_90_counter_clockwise' do
    subject { helper.rotate_90_counter_clockwise(matrix) }

    context 'when matrix is nil' do
      let(:matrix) { nil }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'Expected a array with an n-by-n matrix')
      end
    end

    context 'when matrix is not an array' do
      let(:matrix) { 'matrix' }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'Expected a array with an n-by-n matrix')
      end
    end

    context 'when matrix is not a square matrix' do
      let(:matrix) { [[1, 2], [3, 4], [5, 6]] }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, 'Expected a array with an n-by-n matrix')
      end
    end

    context 'when matrix is a square matrix' do
      let(:matrix) { [[1, 2, 3], [4, 5, 6], [7, 8, 9]] }

      it 'rotates the matrix 90 degrees counter-clockwise' do
        expect(subject).to eq([[3, 6, 9], [2, 5, 8], [1, 4, 7]])
      end
    end
  end
end
