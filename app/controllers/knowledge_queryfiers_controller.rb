require "ai/ai_service_interface"
require "ai/gemini_service"
require "ai/script_tools/kg_tools"
class KnowledgeQueryfiersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :execute_kg ]
  before_action :set_knowledge_queryfier, only: %i[ show edit update destroy ]
  before_action :set_project, only: %i[ export import ]

  # GET /kg_swagger(.json)
  def kg_swagger
    respond_to do |format|
      format.html { render "kg_swagger", layout: false }
      format.json { render json: KnowledgeQueryfier.swagger_json(params[:project_id]) }
    end
  end

  # /kg_api
  def execute_kg
    sub_url = "/#{params[:splat]}"   # "api/questions"
    method  = request.method         # "POST", "GET", etc

    kg_query_obj = KnowledgeQueryfier.where(
      "project_id = :project_id AND meta_data_swagger_docs->>'url' = :sub_url AND LOWER(meta_data_swagger_docs->>'method') = :method",
      project_id: project_id,
      sub_url: sub_url,
      method: method.to_s.downcase
    ).first

    if kg_query_obj
      # Remove Rails-internal keys
      cypher_params = params.to_unsafe_h.except("controller", "action", "project_id", "splat", "format")
      result = Neo4jDriver.session.run(kg_query_obj.cypher_dynamic_query, cypher_params)
      render json: result
    else
      render json: { error: "No matching query found" }, status: :not_found
    end
  end

  # GET /knowledge_queryfiers or /knowledge_queryfiers.json
  def index
    @knowledge_queryfiers = KnowledgeQueryfier.all
  end

  # GET /knowledge_queryfiers/1 or /knowledge_queryfiers/1.json
  def show
  end

  # GET /knowledge_queryfiers/new
  def new
    @knowledge_queryfier = KnowledgeQueryfier.new
  end

  # GET /knowledge_queryfiers/1/edit
  def edit
  end

  # POST /knowledge_queryfiers or /knowledge_queryfiers.json
  def create
    @knowledge_queryfier = KnowledgeQueryfier.new(knowledge_queryfier_params)
    @knowledge_queryfier.user_id = current_user.id
    respond_to do |format|
      if @knowledge_queryfier.save
        format.html { redirect_to @knowledge_queryfier, notice: "Knowledge queryfier was successfully created." }
        format.json { render :show, status: :created, location: @knowledge_queryfier }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @knowledge_queryfier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /knowledge_queryfiers/1 or /knowledge_queryfiers/1.json
  def update
    respond_to do |format|
      if @knowledge_queryfier.update(knowledge_queryfier_params)
        format.html { redirect_to @knowledge_queryfier, notice: "Knowledge queryfier was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @knowledge_queryfier }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @knowledge_queryfier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /knowledge_queryfiers/1 or /knowledge_queryfiers/1.json
  def destroy
    @knowledge_queryfier.destroy!

    respond_to do |format|
      format.html { redirect_to project_knowledge_queryfiers_path, notice: "Knowledge queryfier was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Get /kg_swagger_development
  def kg_swagger_development
    @project = Project.find(params[:id])
    render "kg_swagger_development"
  end
  # POST /kg_swagger_dev_agent
  def kg_swagger_dev_agent
    messages = JSON.parse(params[:messages])
    ai = GeminiService.new
    is_system_message = false
    if messages.length == 1
      is_system_message = true
      messages.unshift({ "role" => "system", "content" => ScriptTools::KgTools.system_prompt(params[:project_id]) })
    end
    response = ai.chat(messages: messages)

    # render json: { reply: response }
    respond_to do |format|
      format.turbo_stream do
        if is_system_message
          messages << { role: "agent", content: response }
          render turbo_stream: turbo_stream.update("chat-messages",
            partial: "knowledge_queryfiers/messages",
            locals: { messages: messages, session_id: params[:session_id] }
          )
        else
          render turbo_stream: turbo_stream.append("chat-messages",
            partial: "knowledge_queryfiers/message_append",
            locals: { role: "agent", content: response, session_id: params[:session_id] }
          )
        end
      end
    end
  end

  def export
    filename = "#{@project.title}_#{@project.id}.json"
    data = KnowledgeQueryfier.where(project_id: @project.id).all.to_json

    send_data data,
              type: "application/json; header=present",
              disposition: "attachment",
              filename: filename
  end

  def import_view
    # simple form to upload JSON
  end

  def import
    file = params[:file] # file uploaded from form
    json_data = JSON.parse(file.read)
    existing_data = KnowledgeQueryfier
      .where(project_id: params[:project_id])
      .pluck(Arel.sql("(meta_data_swagger_docs->>'method')::text || '::' || (meta_data_swagger_docs->>'url')::text"))

    json_data.each do |item|
      key = "#{item["meta_data_swagger_docs"]["method"]}::#{item["meta_data_swagger_docs"]["url"]}"


      # Skip if already exists
      next if existing_data.include?(key)

      # Clean up unwanted fields
      item.delete("id")
      item.delete("created_at")
      item.delete("updated_at")
      item.delete("project_id")

      KnowledgeQueryfier.create!(item.merge("project_id" => @project.id))
    end

    redirect_to project_knowledge_queryfiers_path(@project), notice: "Data imported successfully"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_knowledge_queryfier
      @knowledge_queryfier = KnowledgeQueryfier.find(params.expect(:id))
    end
    def set_project
      @project = Project.find(params[:project_id])
    end

    # Only allow a list of trusted parameters through.
    def knowledge_queryfier_params
      params.expect(knowledge_queryfier: [ :user_id, :project_id, :cypher_dynamic_query, :meta_data_swagger_docs, :tags, :title, :description ])
    end
end
