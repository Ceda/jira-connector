describe 'Jira API' do

  describe 'POST /jira', type: :request do
    # it 'add github label' do
    #   simulate_jira_request 'jira'
    #   expect(response.status).to eq 200
    # end

    it 'assign to user' do
      simulate_jira_request 'jira_assign_update'
      expect(response.status).to eq 200
    end
  end
end
