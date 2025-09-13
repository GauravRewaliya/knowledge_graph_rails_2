class KnowledgeQueryfiersController < ApplicationController
  before_action :set_knowledge_queryfier, only: %i[ show edit update destroy ]

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
