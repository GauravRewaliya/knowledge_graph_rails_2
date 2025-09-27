# lib/ai/gemini_service.rb
require "httparty"

class GeminiService < AiServiceInterface
  include HTTParty

  def initialize(api_key: ENV["GEMINI_API_KEY"], base_url: nil)
    super(api_key: api_key, base_url: base_url || "https://generativelanguage.googleapis.com/v1")
  end

  def chat(messages:, tools: [])
    model = "gemini-2.0-flash"
    url = "#{base_url}/models/#{model}:generateContent?key=#{api_key}"

    payload = {
      contents: messages.map { |msg| { role: msg[:role], parts: [ { text: msg[:content] } ] } }
    }

    response = self.class.post(url,
                               headers: { "Content-Type" => "application/json" },
                               body: payload.to_json)

    if response.success?
      response.dig("candidates", 0, "content", "parts", 0, "text")
    else
      raise "Gemini API Error: #{response.code} - #{response.body}"
    end
  end

  def self.get_models
    [ "gemini-pro", "gemini-1.5-pro" ]
  end
end
