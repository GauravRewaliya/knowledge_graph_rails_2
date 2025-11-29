class ApiLogsController < ApplicationController
  before_action :set_api_log, only: %i[ show edit update destroy ]

  # GET /api_logs or /api_logs.json
  def index
    @api_logs = ApiLog.all
  end

  # GET /api_logs/1 or /api_logs/1.json
  def show
  end

  # DELETE /api_logs/1 or /api_logs/1.json
  def destroy
    @api_log.destroy!

    respond_to do |format|
      format.html { redirect_to api_logs_path, notice: "Api log was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_log
      @api_log = ApiLog.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def api_log_params
      params.expect(api_log: [ :method, :target_url, :request, :response ])
    end
end
