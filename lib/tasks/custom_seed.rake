namespace :custom_seed do
  # rails custom_seed:kn_querifier PROJECT_ID=1 USER_ID=2
  desc "Seed knowledge_queryfiers table for a given project and user"
  task kn_querifier: :environment do
    require "json"
    require "ostruct"

    # Arguments: pass as environment variables
    project_id = ENV["PROJECT_ID"]
    user_id    = ENV["USER_ID"]
    unless user_id
      puts "USER_ID is required. Example: rake knowledge_query:seed USER_ID=2"
      exit
    end

    user = User.find_by(id: user_id)
    unless user
      puts "User with id=#{user_id} not found"
      exit
    end
    if project_id.blank?
      project = Project.create!(
        title: "Project for user #{user_id}",
        desc: "Seed data of Question Bank"
      )
      project_id = project.id
      puts "No PROJECT_ID provided. Created project_id=#{project_id}"
    end

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
                    items: {
                      type: "object",
                      properties: {
                        id: { type: "string", example: "3fa85f64-5717-4562-b3fc-2c963f66afa6" },
                        content: { type: "string", example: "What is 2+2?" },
                        tag: { type: "string", example: "Math" },
                        answers: {
                          type: "array",
                          items: {
                            type: "object",
                            properties: {
                              id: { type: "string" },
                              content: { type: "string" }
                            }
                          }
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
                schema: {
                  type: "object",
                  properties: {
                    content: { type: "string", example: "What is 3+3?" },
                    tag: { type: "string", enum: [ "Math", "Science" ], example: "Math" }
                  },
                  required: [ "content", "tag" ]
                }
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
    # Prepare array for bulk insert
    records = data.map do |item|
      {
        user_id: user_id,
        project_id: project_id,
        cypher_dynamic_query: item[:cypher_dynamic_query],
        meta_data_swagger_docs: item[:meta_data_swagger_docs],
        tags: item[:entity_type],
        title: item[:title],
        description: item[:desc],
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    # Bulk insert
    KnowledgeQueryfier.insert_all(records)

    puts "Seeded #{data.size} knowledge_queryfiers for project_id=#{project_id}, user_id=#{user_id}"
  end
end
