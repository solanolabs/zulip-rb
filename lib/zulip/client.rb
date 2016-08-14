require 'json'
require 'faraday'

require 'zulip/client/messages'
require 'zulip/client/users'
require 'zulip/client/stream_subscriptions'
require 'zulip/client/queue_registration'
require 'zulip/client/event_streaming'
require 'zulip/client/event_parser'

module Zulip
  class Client
    include Zulip::Client::Messages
    include Zulip::Client::Users
    include Zulip::Client::StreamSubscriptions
    include Zulip::Client::QueueRegistration
    include Zulip::Client::EventStreaming
    include Zulip::Client::EventParser

    attr_accessor :email_address, :api_key, :endpoint
    attr_writer :connection

    def initialize
      yield self if block_given?
    end

    def connection
      @connection ||= initialize_connection
    end

    private

    def initialize_connection
      ep = endpoint || "https://zulipchat.com"
      conn = Faraday.new(url: ep)
      conn.basic_auth(email_address, api_key)
      conn
    end

    def json_encode_list(items)
      JSON.generate(Array(items).flatten)
    end

    def parse_response(http_response)
      parse_json(http_response.body)
    end

    def parse_json(json)
      JSON.parse(json)
    end

  end
end
