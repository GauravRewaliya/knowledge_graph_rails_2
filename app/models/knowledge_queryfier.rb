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
  store_accessor :meta_data_swagger_docs, :method, :url, :is_deprecated
  validates :method, :url, presence: true
  validates :method, inclusion: { in: %w[GET POST PUT PATCH DELETE] }

  belongs_to :user, optional: true
  belongs_to :project

  # def self.get_entites(workspace_id = nil)
  #   where(workspace_id: workspace_id, entity_type: "entities") if workspace_id
  #   where(entity_type: "entities")
  # end

  # def self.get_relations(workspace_id = nil)
  #   where(workspace_id: workspace_id, entity_type: "relations") if workspace_id
  #   where(entity_type: "relations")
  # end


  def self.get_cypher_docs
    GraphQueryfier.all
  end


  def execute(cypher_dynamic_query)
    Neo4jDriver.session.run(cypher_dynamic_query)
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
    kg_queries = KnowledgeQueryfier.where(project_id: project_id).all()
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
          "description" => q.description,
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
      "components" => {}
    }

    JSON.pretty_generate(openapi)
  end

  private

  def graph_db
    Neo4jDriver.session
  end
end
