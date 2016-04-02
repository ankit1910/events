shared_examples_for 'AuthenticatesClientRequest' do
  context 'invalid user token' do
    before do
      send_request({}, { 'X-CLIENT-TOKEN' => 'invalid'})
    end

    it 'renders user unauthorized response' do
      @expected = { message: 'The user is unauthorized' }
    end
  end
end
