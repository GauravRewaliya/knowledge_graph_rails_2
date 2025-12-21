class DbScrappersController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_db_scrapper, only: %i[ show edit update destroy ]
  before_action :set_project, only: %i[ har_viewer har_modal ]

  # GET /har_analiser
  def har_analiser
    render "db_scrappers/har_analiser", layout: false
  end

  # GET /projects/:project_id/db_scrappers/har_viewer
  def har_viewer
    render "db_scrappers/har_viewer", layout: "application"
  end

  # GET /projects/:project_id/db_scrappers/har_modal
  def har_modal
    render "db_scrappers/har_modal", layout: false
  end

  # POST /projects/:project_id/db_scrappers/save_har_entries
  def save_har_entries
    return render json: { success: false, error: "No entries provided" }, status: 400 unless params[:entries].present?

    begin
      @db_scrapper = DbScrapper.create!(
        project_id: @project.id,
        user_id: current_user&.id || 1,
        response: params[:entries].to_json,
        meta_data: {
          file_name: params[:file_name],
          total_entries: params[:entries].length,
          parsed_at: Time.now.iso8601,
          source: "har_viewer"
        },
        source_provider: "har_viewer",
        sub_type: "har_upload"
      )

      render json: {
        success: true,
        db_scrapper_id: @db_scrapper.id,
        message: "HAR entries saved successfully"
      }
    rescue => e
      render json: { success: false, error: "Failed to save entries: #{e.message}" }, status: 500
    end
  end

  # GET /db_scrappers or /db_scrappers.json
  def index
    @db_scrappers = DbScrapper.all
  end

  # GET /db_scrappers/1 or /db_scrappers/1.json
  def show
  end

  # GET /db_scrappers/new
  def new
    @db_scrapper = DbScrapper.new
  end

  # GET /db_scrappers/1/edit
  def edit
  end

  # POST /db_scrappers or /db_scrappers.json
  def create
    @db_scrapper = DbScrapper.new(db_scrapper_params)
    @db_scrapper.user_id = current_user.id
    respond_to do |format|
      if @db_scrapper.save
        format.html { redirect_to @db_scrapper, notice: "Db scrapper was successfully created." }
        format.json { render :show, status: :created, location: @db_scrapper }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @db_scrapper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /db_scrappers/1 or /db_scrappers/1.json
  def update
    respond_to do |format|
      if @db_scrapper.update(db_scrapper_params)
        format.html { redirect_to @db_scrapper, notice: "Db scrapper was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @db_scrapper }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @db_scrapper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /db_scrappers/1 or /db_scrappers/1.json
  def destroy
    @db_scrapper.destroy!

    respond_to do |format|
      format.html { redirect_to project_db_scrappers_path(project_id: @project_id), notice: "Db scrapper was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_db_scrapper
      @project_id = params["project_id"]
      @db_scrapper = DbScrapper.find(params.expect(:id))
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    # Only allow a list of trusted parameters through.
    def db_scrapper_params
      params.expect(db_scrapper: [ :user_id, :project_id, :url, :meta_data, :source_provider, :sub_type, :response, :fildered_response, :parser_code, :final_response, :knowledge_storage_cypher_code ])
    end
end
