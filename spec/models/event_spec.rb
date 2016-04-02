require 'spec_helper'

describe Event do

  let(:saved_event) { FactoryGirl.create(:event) }
  let(:event) { FactoryGirl.build(:event, user: saved_event.user) }


  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :start_time }
    it { is_expected.to validate_presence_of :end_time }

    describe '#end_time_is_after_start_time' do
      context 'when both_time_present? is true' do
        context 'when start_time is less than end_time' do
          it { expect(saved_event).to be_valid }
        end

        context 'when start_time equal to end_time' do
          before do
            saved_event.end_time = saved_event.start_time
          end
          it { expect(saved_event).to_not be_valid }
        end

        context 'when start_time greater than end_time' do
          before do
            saved_event.end_time = saved_event.start_time - 2.seconds
          end
          it { expect(saved_event).to_not be_valid }
        end
      end

      context 'when both_time_present? is false' do
        it { expect(saved_event).to be_valid }
      end
    end

    describe '#times_are_not_overlaping' do
      context "when db's start_time is less than self's end_time" do
        before do
          event.end_time = saved_event.start_time + 2.seconds
        end

        context "when db's end_time is greater than self's start_time" do
          before do
            event.start_time = saved_event.end_time - 2.seconds
          end
          it { expect(event).to_not be_valid }
        end

        context "when db's end_time is less than self's start_time" do
          before do
            event.start_time = saved_event.end_time + 2.seconds
            event.end_time = event.start_time + 1.seconds
          end

          it { expect(event).to be_valid }
        end
      end

      context "when db's start_time is greater than self's end_time" do
        before do
          event.end_time = saved_event.start_time - 2.seconds
        end

        context "when db's end_time is greater than self's start_time" do
          before do
            event.start_time = saved_event.end_time - 2.seconds
          end
          it { expect(event).to_not be_valid }
        end

        context "when db's end_time is less than self's start_time" do
          before do
            event.start_time = saved_event.end_time + 2.seconds
            event.end_time = event.start_time + 1.seconds
          end
          it { expect(event).to be_valid }
        end
      end
    end
  end
end
