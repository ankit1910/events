require 'spec_helper'

describe User do
  describe 'Validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :device_token }
    it { is_expected.to validate_uniqueness_of(:device_token).case_insensitive.allow_blank }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:events).dependent(:restrict_with_error) }
  end
end
