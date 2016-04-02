shared_examples_for 'AuthenticatesUserRequest' do
  context 'invalid user token' do
    before do
      send_request({}, { 'X-AUTH-TOKEN' => 'invalid'})
    end

    it 'renders user unauthorized response' do
      @expected = { message: 'The user is unauthorized' }
    end
  end
end
