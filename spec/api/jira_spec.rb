describe 'Jira API' do

  describe 'POST /jira', type: :request do
    it 'work' do

      params = File.read(Rails.root.join('spec', 'fixtures/jira.json'))

      request_headers = {
        'Accept'       => 'application/json',
        'Content-Type' => 'application/json'
      }

      post '/jira', params: params, headers: request_headers

      expect(response.status).to eq 200
    end
  end
end
