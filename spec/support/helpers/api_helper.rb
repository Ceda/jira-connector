module ApiHelper
  def read_fixture(filename)
    File.read(File.join('spec', 'support', 'fixtures', filename))
  end

  def simulate_github_request(fixture, event)
    params = read_fixture("#{fixture}.json")

    post '/github', params:  params,
                    headers: request_headers,
                    env:     { 'HTTP_X_GITHUB_EVENT' => event }
  end

  def simulate_jira_request(fixture)
    params = read_fixture("#{fixture}.json")

    post '/jira', params:  params,
                  headers: request_headers
  end

  private

  def request_headers
    { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
  end
end
