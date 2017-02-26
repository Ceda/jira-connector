class GithubClient
  module Client
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      [:get, :post, :put, :patch].each do |fruit|
        method_name = fruit.to_sym
        define_method(method_name) do |url, payload = nil, headers = {}, &block|
          if method_name == :get
            RestClient.send(method_name, url, params: { access_token: GIT_HUB_TOKEN }, accept: :json)
          else
            RestClient.send(method_name, url, payload.to_json, params: { access_token: GIT_HUB_TOKEN }, accept: :json)
          end
        end
      end
    end
  end

  include Client

  def self.search_user(email)
    RestClient.get 'https://api.github.com/search/users',
      params: { q: email, access_token: GIT_HUB_TOKEN }, accept: :json
  end
end
