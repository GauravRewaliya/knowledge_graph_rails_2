module ScriptTools
  class KgTools
    TOOLS = %w[fetch_current_apis get_row add_row update_row delete_row]
    # Get current Structure
    # def self.current_sturcture(project_id)
    #   # KnowledgeQueryfier.
    # end

    # Prompt to about the KnowledgeQuerifier
    def self.system_prompt(project_id)
      <<~PROMPT
        You are an AI assistant for managing Swagger API documentation.

        TABLE STRUCTURE:
          cypher_dynamic_query   : text
          meta_data_swagger_docs : jsonb, containing:
            - method       : HTTP method as string (GET, POST, PUT, DELETE)
            - url          : endpoint path, e.g., "/api/questions"
            - parameters   : array of parameter objects, each with { name, in, required, type }
            - request_body : object describing request body schema
            - responses    : object mapping status codes to response info, e.g., {
                              "200": { description: "OK", content: { "application/json": { schema: { ... } } } }
                            }
            - is_deprecated: boolean indicating if the endpoint is deprecated
          tags                   : string
          title                  : string
          description            : text

        TOOLS:
          fetch_current_apis, get_row, add_row, update_row, delete_row, system_prompt

        INSTRUCTIONS:
          - When asked to create or modify a Swagger endpoint, respond with JSON tool calls.
          - Use meta_data_swagger_docs in the above structure.
          - Never modify data without calling a tool.
      PROMPT
    end


    # Generic executor for tools
    def self.execute_tool(tool_name, args = {})
      case tool_name.to_s
      when "fetch_current_apis"
          KnowledgeQueryfier
            .select("id", "meta_data_swagger_docs->method", "meta_data_swagger_docs->url", "meta_data_swagger_docs->is_deprecated", "title", "desc")
            .where(project_id: args[:project_id])
            .all
      when "get_row"
          KnowledgeQueryfier.find(args[:id]).to_json
      when "add_row"
          KnowledgeQueryfier.create(args)
      when "update_row"
          kq = KnowledgeQueryfier.find(args[:id])
          kq.update(args)
      when "delete_row"
          kq = KnowledgeQueryfier.find(args[:id])
          kq.delete
      else
          raise ArgumentError, "Unknown tool: #{tool_name}"
      end
    end
  end
end
