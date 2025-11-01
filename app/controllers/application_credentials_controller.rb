class ApplicationCredentialsController < ApplicationController
  before_action :set_application_credential, only: %i[ show edit update destroy ]

  # GET /application_credentials or /application_credentials.json
  def index
    @application_credentials = ApplicationCredential.all
  end

  # GET /application_credentials/1 or /application_credentials/1.json
  def show
  end

  # GET /application_credentials/new
  def new
    @application_credential = ApplicationCredential.new
  end

  # GET /application_credentials/1/edit
  def edit
  end

  # POST /application_credentials or /application_credentials.json
  def create
    @application_credential = ApplicationCredential.new(application_credential_params)

    respond_to do |format|
      if @application_credential.save
        format.html { redirect_to @application_credential, notice: "Application credential was successfully created." }
        format.json { render :show, status: :created, location: @application_credential }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /application_credentials/1 or /application_credentials/1.json
  def update
    respond_to do |format|
      if @application_credential.update(application_credential_params)
        format.html { redirect_to @application_credential, notice: "Application credential was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @application_credential }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application_credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /application_credentials/1 or /application_credentials/1.json
  def destroy
    @application_credential.destroy!

    respond_to do |format|
      format.html { redirect_to application_credentials_path, notice: "Application credential was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application_credential
      @application_credential = ApplicationCredential.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def application_credential_params
      params.expect(application_credential: [ :application_doc_id, :title, :description, :credential_type, :rate_limits, :settings, :auth_data, :is_active ])
    end
end
