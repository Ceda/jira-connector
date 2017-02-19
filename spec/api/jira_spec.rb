describe 'Jira API' do

  describe 'POST /jira', type: :request do
    it 'add github label' do
      simulate_jira_request 'jira'

      expect(response.status).to eq 200
    end
  end
end
