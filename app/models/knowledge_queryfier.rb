# == Schema Information
#
# Table name: knowledge_queryfiers
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  project_id             :integer          not null
#  cypher_dynamic_query   :text
#  meta_data_swagger_docs :jsonb
#  tags                   :string
#  title                  :string
#  description            :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_knowledge_queryfiers_on_project_id  (project_id)
#  index_knowledge_queryfiers_on_user_id     (user_id)
#

class KnowledgeQueryfier < ApplicationRecord
  require "ostruct"

  belongs_to :user, optional: true
  belongs_to :project

  def self.get_cypher_docs
    GraphQueryfier.all
  end


  def execute(cypher_dynamic_query)
    Neo4jDriver.session.run(cypher_dynamic_query)
  end

  def self.sample
    data = [
      # Question queries
      {
        entity_type: "questions",
        title: "questions",
        desc: "Get all questions with their tags and answers",
        cypher_dynamic_query: "MATCH (q:Question)-[:HAS_TAG]->(t:Tag) OPTIONAL MATCH (a:Answer)-[:ANSWERS]->(q) RETURN q.id, q.content, t.name as tag, COLLECT(a {.id, .content}) as answers",
        meta_data_swagger_docs: {
          method: "GET",
          url: "/api/questions",
          parameters: [],
          request_body: nil,
          responses: {
            "200" => {
              description: "List of questions",
              content: {
                "application/json" => {
                  schema: {
                    type: "array",
                    items: { "$ref": "#/components/schemas/Question" }
                    # {
                    #   type: "object",
                    #   properties: {
                    #     id: { type: "string", example: "3fa85f64-5717-4562-b3fc-2c963f66afa6" },
                    #     content: { type: "string", example: "What is 2+2?" },
                    #     tag: { type: "string", example: "Math" },
                    #     answers: {
                    #       type: "array",
                    #       items: {
                    #         type: "object",
                    #         properties: {
                    #           id: { type: "string" },
                    #           content: { type: "string" }
                    #         }
                    #       }
                    #     }
                    #   }
                    # }
                  },
                  example: [
                    { id: "uuid", content: "What is 2+2?", tag: "Math", answers: [] }
                  ]
                }
              }
            }
          },
          is_deprecated: false
        }
      },
      {
        entity_type: "questions",
        title: "questions",
        desc: "Get questions by tag",
        cypher_dynamic_query: "MATCH (q:Question)-[:HAS_TAG]->(t:Tag {name: $tag}) OPTIONAL MATCH (a:Answer)-[:ANSWERS]->(q) RETURN q.id, q.content, t.name as tag, COLLECT(a {.id, .content}) as answers",
        meta_data_swagger_docs: {
          method: "GET",
          url: "/api/questions/by_tag/{tag}",
          parameters: [
            {
              name: "tag",
              in: "path",
              required: true,
              schema: { type: "string", enum: [ "Math", "Science" ], example: "Math" },
              description: "Filter questions by tag"
            }
          ],
          request_body: nil,
          responses: {
            "200" => {
              description: "List of questions by tag",
              content: {
                "application/json" => {
                  schema: {
                    type: "array",
                    items: {
                      type: "object",
                      properties: {
                        id: { type: "string" },
                        content: { type: "string" },
                        tag: { type: "string" },
                        answers: {
                          type: "array",
                          items: { type: "object" }
                        }
                      }
                    }
                  },
                  example: [
                    { id: "uuid", content: "What is 2+2?", tag: "Math", answers: [] }
                  ]
                }
              }
            }
          },
          is_deprecated: false
        }
      },
      {
        entity_type: "questions",
        title: "questions",
        desc: "Create a new question with tag",
        cypher_dynamic_query: "MERGE (t:Tag {name: $tag}) CREATE (q:Question {id: randomUUID(), content: $content})-[:HAS_TAG]->(t) RETURN q.id, q.content",
        meta_data_swagger_docs: {
          method: "POST",
          url: "/api/questions",
          parameters: [],
          request_body: {
            required: true,
            content: {
              "application/json" => {
                schema: { "$ref": "#/components/schemas/Question" }
                # {
                #   type: "object",
                #   properties: {
                #     content: { type: "string", example: "What is 3+3?" },
                #     tag: { type: "string", enum: [ "Math", "Science" ], example: "Math" }
                #   },
                #   required: [ "content", "tag" ]
                # }
              }
            }
          },
          responses: {
            "200" => {
              description: "Question created",
              content: {
                "application/json" => {
                  schema: {
                    type: "object",
                    properties: {
                      id: { type: "string", example: "3fa85f64-5717-4562-b3fc-2c963f66afa6" },
                      content: { type: "string", example: "What is 3+3?" }
                    }
                  }
                }
              }
            }
          },
          is_deprecated: false
        }
      },
      # Answer queries
      {
        entity_type: "answers",
        title: "answers",
        desc: "Add answer to question",
        cypher_dynamic_query: "MATCH (q:Question {id: $question_id}) CREATE (a:Answer {id: randomUUID(), content: $content})-[:ANSWERS]->(q) RETURN a.id, a.content",
        meta_data_swagger_docs: {
          method: "POST",
          url: "/api/questions/{question_id}/answers",
          parameters: [
            {
              name: "question_id",
              in: "path",
              required: true,
              schema: { type: "string", example: "3fa85f64-5717-4562-b3fc-2c963f66afa6" }
            }
          ],
          request_body: {
            required: true,
            content: {
              "application/json" => {
                schema: {
                  type: "object",
                  properties: {
                    content: { type: "string", example: "6" }
                  },
                  required: [ "content" ]
                }
              }
            }
          },
          responses: {
            "200" => {
              description: "Answer created",
              content: {
                "application/json" => {
                  schema: {
                    type: "object",
                    properties: {
                      id: { type: "string", example: "3fa85f64-5717-4562-b3fc-2c963f66afa6" },
                      content: { type: "string", example: "6" }
                    }
                  }
                }
              }
            }
          },
          is_deprecated: false
        }
      },
      {
        entity_type: "answers",
        title: "answers",
        desc: "Get all answers for a question",
        cypher_dynamic_query: "MATCH (a:Answer)-[:ANSWERS]->(q:Question {id: $question_id}) RETURN a.id, a.content",
        meta_data_swagger_docs: {
          method: "GET",
          url: "/api/questions/{question_id}/answers",
          parameters: [
            {
              name: "question_id",
              in: "path",
              required: true,
              schema: { type: "string", example: "3fa85f64-5717-4562-b3fc-2c963f66afa6" }
            }
          ],
          request_body: nil,
          responses: {
            "200" => {
              description: "List of answers",
              content: {
                "application/json" => {
                  schema: {
                    type: "array",
                    items: {
                      type: "object",
                      properties: {
                        id: { type: "string" },
                        content: { type: "string" }
                      }
                    }
                  },
                  example: [ { id: "uuid", content: "6" } ]
                }
              }
            }
          },
          is_deprecated: false
        }
      },
      # Tag queries
      {
        entity_type: "tags",
        title: "tags",
        desc: "Get all tags",
        cypher_dynamic_query: "MATCH (t:Tag) RETURN t.name",
        meta_data_swagger_docs: {
          method: "GET",
          url: "/api/tags",
          parameters: [],
          request_body: nil,
          responses: {
            "200" => {
              description: "List of tags",
              content: {
                "application/json" => {
                  schema: {
                    type: "array",
                    items: {
                      type: "object",
                      properties: {
                        name: { type: "string" }
                      }
                    }
                  },
                  example: [ { name: "Math" }, { name: "Science" } ]
                }
              }
            }
          },
          is_deprecated: false
        }
      },
      {
        entity_type: "tags",
        title: "tags",
        desc: "Get tag hierarchy",
        cypher_dynamic_query: "MATCH (t:Tag)-[:PARENT_TAG*0..]->(parent:Tag) WHERE t.name = $tag RETURN t.name, COLLECT(parent.name) as hierarchy",
        meta_data_swagger_docs: {
          method: "GET",
          url: "/api/tags/{tag}/hierarchy",
          parameters: [
            {
              name: "tag",
              in: "path",
              required: true,
              schema: { type: "string", example: "Addition" }
            }
          ],
          request_body: nil,
          responses: {
            "200" => {
              description: "Tag hierarchy",
              content: {
                "application/json" => {
                  schema: {
                    type: "object",
                    properties: {
                      name: { type: "string" },
                      hierarchy: {
                        type: "array",
                        items: { type: "string" }
                      }
                    }
                  },
                  example: { name: "Addition", hierarchy: [ "Math" ] }
                }
              }
            }
          },
          is_deprecated: false
        }
      },
      # Comment queries
      {
        entity_type: "comments",
        title: "comments",
        desc: "Get all comments for a question",
        cypher_dynamic_query: "MATCH (c:Comment)-[:COMMENTS_ON]->(q:Question {id: $question_id}) RETURN c.id, c.text, c.user_id, c.created_at",
        meta_data_swagger_docs: {
          method: "GET",
          url: "/api/questions/{question_id}/comments",
          parameters: [
            {
              name: "question_id",
              in: "path",
              required: true,
              schema: { type: "string", example: "3fa85f64-5717-4562-b3fc-2c963f66afa6" }
            }
          ],
          request_body: nil,
          responses: {
            "200" => {
              description: "List of comments",
              content: {
                "application/json" => {
                  schema: {
                    type: "array",
                    items: {
                      type: "object",
                      properties: {
                        id: { type: "string" },
                        text: { type: "string" },
                        user_id: { type: "string" },
                        created_at: { type: "string", format: "date-time" }
                      }
                    }
                  },
                  example: [
                    { id: "uuid", text: "Great question!", user_id: "user123", created_at: "2024-01-01T00:00:00Z" }
                  ]
                }
              }
            }
          },
          is_deprecated: false
        }
      },
      {
        entity_type: "comments",
        title: "comments",
        desc: "Create comment on question",
        cypher_dynamic_query: "MATCH (q:Question {id: $question_id}) CREATE (c:Comment {id: randomUUID(), text: $text, user_id: $user_id, created_at: datetime()})-[:COMMENTS_ON]->(q) RETURN c.id, c.text",
        meta_data_swagger_docs: {
          method: "POST",
          url: "/api/questions/{question_id}/comments",
          parameters: [
            {
              name: "question_id",
              in: "path",
              required: true,
              schema: { type: "string", example: "3fa85f64-5717-4562-b3fc-2c963f66afa6" }
            }
          ],
          request_body: {
            required: true,
            content: {
              "application/json" => {
                schema: {
                  type: "object",
                  properties: {
                    text: { type: "string", example: "Great question!" },
                    user_id: { type: "string", example: "user123" }
                  },
                  required: [ "text", "user_id" ]
                }
              }
            }
          },
          responses: {
            "200" => {
              description: "Comment created",
              content: {
                "application/json" => {
                  schema: {
                    type: "object",
                    properties: {
                      id: { type: "string", example: "3fa85f64-5717-4562-b3fc-2c963f66afa6" },
                      text: { type: "string", example: "Great question!" }
                    }
                  }
                }
              }
            }
          },
          is_deprecated: false
        }
      },
      # Relation queries
      {
        entity_type: "relations",
        title: "relations",
        desc: "Get all relationship types",
        cypher_dynamic_query: "CALL db.relationshipTypes() YIELD relationshipType RETURN relationshipType",
        meta_data_swagger_docs: {
          method: "GET",
          url: "/api/relations",
          parameters: [],
          request_body: nil,
          responses: {
            "200" => {
              description: "List of relationships",
              content: {
                "application/json" => {
                  schema: {
                    type: "array",
                    items: {
                      type: "object",
                      properties: {
                        relationshipType: { type: "string" }
                      }
                    }
                  },
                  example: [
                    { relationshipType: "HAS_TAG" },
                    { relationshipType: "ANSWERS" }
                  ]
                }
              }
            }
          },
          is_deprecated: false
        }
      },
      {
        entity_type: "entities",
        title: "entities",
        desc: "Get all node labels/entities",
        cypher_dynamic_query: "CALL db.labels() YIELD label RETURN label",
        meta_data_swagger_docs: {
          method: "GET",
          url: "/api/entities",
          parameters: [],
          request_body: nil,
          responses: {
            "200" => {
              description: "List of entities",
              content: {
                "application/json" => {
                  schema: {
                    type: "array",
                    items: {
                      type: "object",
                      properties: {
                        label: { type: "string" }
                      }
                    }
                  },
                  example: [
                    { label: "Question" },
                    { label: "Answer" },
                    { label: "Tag" }
                  ]
                }
              }
            }
          },
          is_deprecated: false
        }
      }
    ]
    data.map { |h| OpenStruct.new(h) }
  end
  # --- helper normalizers ---
  def self.normalize_meta_hash(meta)
    # Accept meta as symbol- or string-keyed Hash or OpenStruct-like
    mh = meta.to_h.transform_keys { |k| k.to_s }
    # Normalize small key names
    normalized = {}

    normalized["url"]          = mh["url"].to_s
    normalized["method"]       = mh["method"].to_s.upcase
    normalized["is_deprecated"] = mh.fetch("is_deprecated", false)
    normalized["parameters"]   = mh.fetch("parameters", []) || []
    normalized["request_body"] = mh.fetch("request_body", nil)
    normalized["responses"]    = mh.fetch("responses", nil)
    normalized
  end

  # --- swagger builder ---
  def self.component_structure(project_id)
    {
      "schemas" => {
        "Question" => {
          "type" => "object",
          "properties" => {
            "id"      => { "type" => "string", "format" => "uuid" },
            "content" => { "type" => "string" },
            "tag"     => { "type" => "string" },
            "answers" => { "type" => "array", "items" => { "$ref" => "#/components/schemas/Answer" } }
          },
          "example" => { "id" => "3fa85f64-5717-4562-b3fc-2c963f66afa6", "content" => "What is 2+2?", "tag" => "Math", "answers" => [] }
        },
        "Answer" => {
          "type" => "object",
          "properties" => {
            "id"      => { "type" => "string", "format" => "uuid" },
            "content" => { "type" => "string" }
          },
          "example" => { "id" => "3fa85f64-5717-4562-b3fc-2c963f66afa6", "content" => "4" }
        },
        "Tag" => {
          "type" => "object",
          "properties" => { "name" => { "type" => "string" } },
          "example" => { "name" => "Math" }
        },
        "Comment" => {
          "type" => "object",
          "properties" => {
            "id"         => { "type" => "string", "format" => "uuid" },
            "text"       => { "type" => "string" },
            "user_id"    => { "type" => "string" },
            "created_at" => { "type" => "string", "format" => "date-time" }
          },
          "example" => { "id" => "3fa85f64-5717-4562-b3fc-2c963f66afa6", "text" => "Great question!", "user_id" => "user123", "created_at" => "2024-01-01T00:00:00Z" }
        },
        "Relation" => {
          "type" => "object",
          "properties" => { "relationshipType" => { "type" => "string" } },
          "example" => { "relationshipType" => "HAS_TAG" }
        },
        "Entity" => {
          "type" => "object",
          "properties" => { "label" => { "type" => "string" } },
          "example" => { "label" => "Question" }
        }
      },
      "parameters" => {
        "UUIDParam" => {
          "name" => "id", "in" => "path", "required" => true,
          "schema" => { "type" => "string", "format" => "uuid" },
          "example" => "3fa85f64-5717-4562-b3fc-2c963f66afa6"
        },
        "TagParam" => {
          "name" => "tag", "in" => "path", "required" => true,
          "schema" => { "type" => "string", "enum" => [ "Math", "Science" ] },
          "example" => "Math"
        }
      },
      "examples" => {
        "QuestionExample1" => { "value" => { "id" => "3fa85f64-5717-4562-b3fc-2c963f66afa6", "content" => "What is 2+2?", "tag" => "Math", "answers" => [] } },
        "QuestionExample2" => { "value" => { "id" => "3fa85f64-5717-4562-b3fc-2c963f66afa6", "content" => "What is gravity?", "tag" => "Science", "answers" => [] } }
      }
    }
  end
  def self.swagger_json(project_id)
    kg_queries = KnowledgeQueryfier.sample
    paths = {}

    kg_queries.each do |q|
      docs = q.meta_data_swagger_docs.is_a?(Array) ? q.meta_data_swagger_docs : [ q.meta_data_swagger_docs ]
      docs.each do |meta_raw|
        meta = normalize_meta_hash(meta_raw)
        url = meta["url"].to_s
        next if url.empty?

        url = "/#{url}" unless url.start_with?("/")
        method = (meta["method"] || "GET").downcase

        paths[url] ||= {}

        # Parameters
        parameters = (meta["parameters"] || []).map do |p|
          ph = p.to_h.transform_keys(&:to_s)
          {
            "name"        => ph["name"],
            "in"          => ph["in"] || "path",
            "required"    => ph.key?("required") ? ph["required"] : (ph["in"] == "path"),
            "schema"      => ph["schema"],
            "description" => ph["description"]
          }.compact
        end

        # Request body
        request_body = nil
        if meta["request_body"]
          rb = meta["request_body"].to_h.transform_keys(&:to_s)
          request_body = {
            "required" => rb.fetch("required", false),
            "content"  => rb["content"] || {}
          }
        end

        # Responses (default fallback)
        responses = meta["responses"] || {
          "200" => {
            "description" => "Successful response",
            "content" => {
              "application/json" => {
                "schema"  => { "type" => "object" },
                "example" => meta.dig(:examples, 0, :response)
              }
            }
          }
        }

        paths[url][method] = {
          "summary"     => q.title,
          "description" => q.desc,
          "deprecated"  => meta["is_deprecated"] || false,
          "parameters"  => parameters.empty? ? nil : parameters,
          "requestBody" => request_body,
          "responses"   => responses
        }.compact
      end
    end

    openapi = {
      "openapi" => "3.0.0",
      "info" => {
        "title"       => "Knowledge Graph API",
        "version"     => "1.0.0",
        "description" => "Dynamic Knowledge Graph APIs with Questions, Answers, Tags, Comments, Relations, Entities"
      },
      "servers" => [
        { "url" => "/projects/#{project_id}/kg_api", "description" => "Project KG API" }
      ],
      "paths" => paths,
      "components" => KnowledgeQueryfier.component_structure(project_id)
    }

    JSON.pretty_generate(openapi)
  end

  private

  def graph_db
    Neo4jDriver.session
  end
end
