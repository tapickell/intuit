require "oauth"

module Intuit
  class Client
    autoload :RetrieveAllRequest,  "intuit/client/retrieve_all_request"
    autoload :CreateRequest,       "intuit/client/create_request"

    autoload :RetrieveAllResponse, "intuit/client/retrieve_all_response"
    autoload :CreateResponse,      "intuit/client/create_response"

    INTUIT_OAUTH_URL  = "https://oauth.intuit.com"
    API_URL           = "https://appcenter.intuit.com/api/v1"
    DATA_SERVICES_URL = "https://services.intuit.com/sb"

    class << self
      attr_accessor :token, :secret, :realm_id

      def request_token(callback)
        consumer.get_request_token(:oauth_callback => callback)
      end

      def menu
        client.get("#{API_URL}/Account/AppMenu").body
      end

      def client
        OAuth::AccessToken.new(consumer, token, secret)
      end

      def retrieve_all(resource)
        perform_request :retrieve_all, resource
      end

      def create(resource)
        perform_request :create, resource
      end

      private

      def consumer
        @consumer ||= OAuth::Consumer.new(
          Intuit.oauth_consumer_key,
          Intuit.oauth_consumer_secret,
          :site               => INTUIT_OAUTH_URL,
          :request_token_path => "/oauth/v1/get_request_token",
          :access_token_path  => "/oauth/v1/get_access_token",
          :authorize_url      => "https://workplace.intuit.com/Connect/Begin"
        )
      end

      def perform_request(request_name, resource)
        request = Client.const_get("#{request_name.to_s.camelize}Request").new(client, resource)
        response = Client.const_get("#{request_name.to_s.camelize}Response").new(request.perform, resource)
        response.result
      end
    end
  end
end
