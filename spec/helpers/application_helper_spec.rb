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
        it { is_expected.to eq('a' * 100 + '...') }
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
        it { is_expected.to eq('a' * length + '...') }
      end
    end
  end
end
