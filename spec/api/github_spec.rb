describe 'Github API' do

  describe 'POST /github', type: :request do
    it 'work' do

      params = File.read(Rails.root.join('spec', 'fixtures/github.json'))

      request_headers = {
        'Accept'       => 'application/json',
        'Content-Type' => 'application/json'
      }

      post '/github', params: params, headers: request_headers, env: { 'HTTP_X_GITHUB_EVENT' => 'pull_request'}

      expect(response.status).to eq 200
    end
  end
end
