require 'spec_helper'

describe Api::EventsController, type: 'request' do
  shared_examples_for 'RequestToFindEvent' do
    context 'when event not found' do
      before do
        send_request({}, {}, 0)
      end

      it 'renders not found response' do
        @expected = { message: 'Event not found' }
      end
    end
  end

  let!(:user) { FactoryGirl.create(:user) }
  let!(:event) { FactoryGirl.create(:event, user: user) }

  def request_headers
    {
      'X-AUTH-TOKEN' => user.device_token,
      'X-CLIENT-TOKEN' => API_CLIENT_TOKEN
    }
  end

  describe '#index' do
    def send_request(params = {}, headers = {})
      get api_events_path, params, request_headers.merge(headers)
    end

    it_behaves_like 'AuthenticatesUserRequest'
    it_behaves_like 'AuthenticatesClientRequest'

    it "renders event json" do
      send_request
      @expected = {
        events: [
          {
            id: event.id,
            start_time: event.start_time.to_s(:date_time),
            end_time: event.end_time.to_s(:date_time)
          }
        ]
      }
    end
  end

  describe '#create' do
    before do
      @start_time = Time.current + 1.days
      @end_time = @start_time + 10.seconds
    end

    def send_request(params = {}, headers = {})
      post api_events_path, { event: { start_time: @start_time, end_time: @end_time }.merge(params) }, request_headers.merge(headers)
    end

    it_behaves_like 'AuthenticatesUserRequest'
    it_behaves_like 'AuthenticatesClientRequest'

    context 'when event created successfully' do
      it "renders success response" do
        send_request
        @expected = {
          event: {
            id: Event.last.id,
            start_time: @start_time.to_s(:date_time),
            end_time: @end_time.to_s(:date_time)
          }
        }
      end
    end

    context 'when event creation fails' do
      it "renders error response" do
        send_request({ start_time: nil })
        @expected = {
          errors: {
            start_time: ["can't be blank"]
          }
        }
      end
    end
  end

  describe '#show' do
    def send_request(params = {}, headers = {}, event_id = nil)
      event_id ||= event.id
      get api_event_path(event_id), params, request_headers.merge(headers)
    end

    it_behaves_like 'AuthenticatesUserRequest'
    it_behaves_like 'AuthenticatesClientRequest'
    it_behaves_like 'RequestToFindEvent'

    context 'when event found' do
      it "renders event json" do
        send_request
        @expected = {
          event: {
            id: event.id,
            start_time: event.start_time.to_s(:date_time),
            end_time: event.end_time.to_s(:date_time)
          }
        }
      end
    end
  end

  describe '#update' do
    before do
      @start_time = Time.current + 1.days
      @end_time = @start_time + 10.seconds
    end

    def send_request(params ={}, headers= {}, event_id = nil)
      event_id ||= event.id
      patch api_event_path(event_id), { event: { start_time: @start_time , end_time: @end_time }.merge(params) }, request_headers.merge(headers)
    end

    it_behaves_like 'AuthenticatesUserRequest'
    it_behaves_like 'AuthenticatesClientRequest'
    it_behaves_like 'RequestToFindEvent'

    context 'when event updated successfully' do
      it "renders success response" do
        send_request
        @expected = {
          event: {
            id: event.id,
            start_time: @start_time.to_s(:date_time),
            end_time: @end_time.to_s(:date_time)
          }
        }
      end
    end

    context 'when event updation fails' do
      it "renders error response" do
        send_request({ start_time: nil })
        @expected = {
          errors: {
            start_time: ["can't be blank"]
          }
        }
      end
    end
  end

  describe '#destroy' do
    def send_request(params ={}, headers= {}, event_id = nil)
      event_id ||= event.id
      delete api_event_path(event_id), params, request_headers.merge(headers)
    end

    it_behaves_like 'AuthenticatesUserRequest'
    it_behaves_like 'AuthenticatesClientRequest'
    it_behaves_like 'RequestToFindEvent'

    context 'when event deleted successfully' do
      it "renders success response" do
        send_request
        @expected = { message: 'Event destroyed successfully.' }
      end
    end

    context 'when event deletion fails' do
      before do
        allow_any_instance_of(Event).to receive(:destroy).and_return(false)
        send_request
      end

      it "renders error response" do
        @expected = {
          errors: {}
        }
      end
    end
  end
  after { expect(response.body).to eq(@expected.to_json) }
end
