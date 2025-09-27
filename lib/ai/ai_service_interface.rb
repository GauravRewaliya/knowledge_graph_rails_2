# lib/ai/ai_service_interface.rb
class AiServiceInterface
  attr_reader :api_key, :base_url

  def initialize(api_key:, base_url: nil)
    @api_key = api_key
    @base_url = base_url
  end

  # Public entry point for chat
  # messages: [{ role: "user", content: "hi" }]
  # tools: [{ name:, action: -> {} }]
  def chat(messages:, tools: [])
    raise NotImplementedError, "Subclasses must implement #chat"
  end

  # Stub: future tool execution logic
  def handle_tools(tools, message)
    tools.each do |tool|
      if message.include?(tool[:name])
        return tool[:action].call(message)
      end
    end
    nil
  end

  def self.get_models
    []
  end
end
