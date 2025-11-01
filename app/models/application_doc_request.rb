class ApplicationDocRequest < ApplicationRecord
  belongs_to :application_doc

  store :swagger_data, accessors: [
    :method,
    :path,
    :parameters,
    :request_body,
    :responses,
    :examples,
    :tags,
    :is_deprecated,
    :headers,
    :security
  ], coder: JSON

  # Example of swagger_data structure:
  # {
  #   method: "GET",
  #   path: "/v1/images/search",
  #   parameters: [
  #     { name: "q", in: "query", required: true, type: "string" }
  #   ],
  #   request_body: {
  #     content: {
  #       "application/json": {
  #         schema: {
  #           type: "object",
  #           properties: {
  #             model: { type: "string", default: "gpt-3.5-turbo" }
  #           }
  #         }
  #       }
  #     }
  #   },
  #   responses: {
  #     "200": {
  #       description: "Success"
  #     }
  #   },
  #   examples: [
  #     {
  #       name: "Basic search",
  #       request: { q: "coffee" },
  #       response: { images: [...] }
  #     }
  #   ],
  #   tags: ["images", "search"],
  #   is_deprecated: false,
  #   headers: {
  #     "Content-Type": "application/json"
  #   }
  # }
end
