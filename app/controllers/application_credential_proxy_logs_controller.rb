class ApplicationCredentialProxyLogsController < ApplicationController
  before_action :set_application_credential_proxy_log, only: %i[ show edit update destroy ]

  # GET /application_credential_proxy_logs or /application_credential_proxy_logs.json
  def index
    @application_credential_proxy_logs = ApplicationCredentialProxyLog.all
  end

  # GET /application_credential_proxy_logs/1 or /application_credential_proxy_logs/1.json
  def show
  end

  # GET /application_credential_proxy_logs/new
  def new
    @application_credential_proxy_log = ApplicationCredentialProxyLog.new
  end

  # GET /application_credential_proxy_logs/1/edit
  def edit
  end

  # POST /application_credential_proxy_logs or /application_credential_proxy_logs.json
  def create
    @application_credential_proxy_log = ApplicationCredentialProxyLog.new(application_credential_proxy_log_params)

    respond_to do |format|
      if @application_credential_proxy_log.save
        format.html { redirect_to @application_credential_proxy_log, notice: "Application credential proxy log was successfully created." }
        format.json { render :show, status: :created, location: @application_credential_proxy_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @application_credential_proxy_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /application_credential_proxy_logs/1 or /application_credential_proxy_logs/1.json
  def update
    respond_to do |format|
      if @application_credential_proxy_log.update(application_credential_proxy_log_params)
        format.html { redirect_to @application_credential_proxy_log, notice: "Application credential proxy log was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @application_credential_proxy_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @application_credential_proxy_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /application_credential_proxy_logs/1 or /application_credential_proxy_logs/1.json
  def destroy
    @application_credential_proxy_log.destroy!

    respond_to do |format|
      format.html { redirect_to application_credential_proxy_logs_path, notice: "Application credential proxy log was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application_credential_proxy_log
      @application_credential_proxy_log = ApplicationCredentialProxyLog.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def application_credential_proxy_log_params
      params.expect(application_credential_proxy_log: [ :application_doc_id, :application_credential_id, :user_id, :request_data, :response_data, :requested_at, :finished_at, :credits_used, :duration_ms ])
    end
end
