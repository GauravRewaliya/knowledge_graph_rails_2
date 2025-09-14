class KnowledgeQueryfiersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:execute_kg]
  before_action :set_knowledge_queryfier, only: %i[ show edit update destroy ]

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

    kg_query_obj = KnowledgeQueryfier.sample.find do |x|
      x.meta_data_swagger_docs[:url] == sub_url &&
      x.meta_data_swagger_docs[:method].casecmp?(method)
    end

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_knowledge_queryfier
      @knowledge_queryfier = KnowledgeQueryfier.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def knowledge_queryfier_params
      params.expect(knowledge_queryfier: [ :user_id, :project_id, :cypher_dynamic_query, :meta_data_swagger_docs, :tags, :title, :description ])
    end
end
