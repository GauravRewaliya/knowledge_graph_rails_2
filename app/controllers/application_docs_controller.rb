class ApplicationDocsController < ApplicationController
  before_action :set_application_doc, only: %i[ show edit update destroy ]

  # GET /application_docs or /application_docs.json
  def index
    @application_docs = ApplicationDoc.all
  end

  # GET /application_docs/1 or /application_docs/1.json
  def show
    @application_doc_requests = @application_doc.application_doc_requests
    @application_credentials = @application_doc.application_credentials
  end

  # GET /application_docs/new
  def new
    @application_doc = ApplicationDoc.new
  end

  # GET /application_docs/1/edit
  def edit
  end

  # POST /application_docs or /application_docs.json
  def create
    @application_doc = ApplicationDoc.new(application_doc_params)

    respond_to do |format|
      if @application_doc.save
        format.html { redirect_to @application_doc, notice: "Application doc was successfully created." }
        format.json { render :show, status: :created, location: @application_doc }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /application_docs/1 or /application_docs/1.json
  def update
    respond_to do |format|
      if @application_doc.update(application_doc_params)
        format.html { redirect_to @application_doc, notice: "Application doc was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @application_doc }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application_doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /application_docs/1 or /application_docs/1.json
  def destroy
    @application_doc.destroy!

    respond_to do |format|
      format.html { redirect_to application_docs_path, notice: "Application doc was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Custom actions
  def import_curl
    # Import logic here
  end

  # SWAGGER SPECIFIC ACTIONS
  def swagger
    respond_to do |format|
      format.html { render "swagger", layout: false }
      format.json { render json: generate_swagger_json(@application_doc) }
    end
  end

  def swagger_ui
    render "swagger_ui", layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application_doc
      @application_doc = ApplicationDoc.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def application_doc_params
      params.expect(application_doc: [ :title, :description, :base_url, :tags, :is_active, :docs, :auth_fields ])
    end
end
