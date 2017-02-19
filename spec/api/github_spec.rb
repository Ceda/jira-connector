describe 'Github API' do

  describe 'POST /github', type: :request do
    # it 'assign jira ticket to user' do
    #   simulate_github_request 'github_assign_pr', 'pull_request'
    #   expect(response.status).to eq 200
    # end

    # context 'change jira status' do
    #   it 'by label' do
    #     simulate_github_request 'github_assign_label', 'pull_request'
    #     expect(response.status).to eq 200
    #   end
    #
    #   context 'on review' do
    #     it 'requested to Code Review' do
    #       simulate_github_request 'github_pr_review_requested', 'pull_request'
    #       expect(response.status).to eq 200
    #     end
    #
    #     it 'approved to Quality Assurance' do
    #       simulate_github_request 'github_pr_review_request_approved', 'pull_request'
    #       expect(response.status).to eq 200
    #     end
    #
    #     it 'changes requested to To Do' do
    #       simulate_github_request 'github_pr_review_request_changes', 'pull_request'
    #       expect(response.status).to eq 200
    #     end
    #   end
    #
    #   it 'to In Progress on branch create' do
    #     simulate_github_request 'github_create_branch', 'create'
    #     expect(response.status).to eq 200
    #   end
    #
    #   it 'to Acceptance Testing on or merge' do
    #     simulate_github_request 'github_merge_pr', 'pull_request'
    #     expect(response.status).to eq 200
    #   end
    #
    #   it 'to In Progress on create PR ' do
    #     simulate_github_request 'github_create_pr', 'pull_request'
    #     expect(response.status).to eq 200
    #   end
    # end
  end
end
