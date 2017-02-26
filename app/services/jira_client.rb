class JiraClient
  module Client
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      [:get, :post, :put, :patch].each do |fruit|
        method_name = fruit.to_sym
        define_method(method_name) do |url, payload = nil, headers = {}, &block|
          if method_name == :get
            RestClient.send(method_name, url, HEADERS)
          else
            RestClient.send(method_name, url, payload.to_json, HEADERS)
          end
        end
      end
    end
  end

  include Client
end
