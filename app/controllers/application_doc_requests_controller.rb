class ApplicationDocRequestsController < ApplicationController
  before_action :set_application_doc_request, only: %i[ show edit update destroy ]

  # GET /application_doc_requests or /application_doc_requests.json
  def index
    @application_doc_requests = ApplicationDocRequest.all
  end

  # GET /application_doc_requests/1 or /application_doc_requests/1.json
  def show
  end

  # GET /application_doc_requests/new
  def new
    @application_doc_request = ApplicationDocRequest.new
  end

  # GET /application_doc_requests/1/edit
  def edit
  end

  # POST /application_doc_requests or /application_doc_requests.json
  def create
    @application_doc_request = ApplicationDocRequest.new(application_doc_request_params)

    respond_to do |format|
      if @application_doc_request.save
        format.html { redirect_to @application_doc_request, notice: "Application doc request was successfully created." }
        format.json { render :show, status: :created, location: @application_doc_request }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @application_doc_request.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /application_doc_requests/1 or /application_doc_requests/1.json
  def update
    respond_to do |format|
      if @application_doc_request.update(application_doc_request_params)
        format.html { redirect_to @application_doc_request, notice: "Application doc request was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @application_doc_request }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @application_doc_request.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /application_doc_requests/1 or /application_doc_requests/1.json
  def destroy
    @application_doc_request.destroy!

    respond_to do |format|
      format.html { redirect_to application_doc_requests_path, notice: "Application doc request was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application_doc_request
      @application_doc_request = ApplicationDocRequest.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def application_doc_request_params
      params.expect(application_doc_request: [ :application_doc_id, :title, :description, :curl_template, :swagger_data ])
    end
end
