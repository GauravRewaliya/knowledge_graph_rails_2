# lib/ai/openai_service.rb
require "httparty"

class OpenAIService < AiServiceInterface
  include HTTParty

  def initialize(api_key: ENV["OPENAI_API_KEY"], base_url: nil)
    default_url = ENV["OPENROUTER_API_URL"] || "https://api.openai.com/v1"
    super(api_key: api_key, base_url: base_url || default_url)
  end

  def chat(messages:, tools: [])
    url = "#{base_url}/chat/completions"

    payload = {
      model: "gpt-4o-mini",
      messages: messages.map { |msg| { role: msg[:role], content: msg[:content] } }
    }

    response = self.class.post(url,
                               headers: {
                                 "Content-Type" => "application/json",
                                 "Authorization" => "Bearer #{api_key}"
                               },
                               body: payload.to_json)

    if response.success?
      response.dig("choices", 0, "message", "content")
    else
      raise "OpenAI API Error: #{response.code} - #{response.body}"
    end
  end

  def self.get_models
    [ "gpt-4o-mini", "gpt-4-turbo", "gpt-3.5-turbo" ]
  end
end
