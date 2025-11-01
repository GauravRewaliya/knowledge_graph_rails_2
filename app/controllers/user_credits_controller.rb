class UserCreditsController < ApplicationController
  before_action :set_user_credit, only: %i[ show edit update destroy ]

  # GET /user_credits or /user_credits.json
  def index
    @user_credits = UserCredit.all
  end

  # GET /user_credits/1 or /user_credits/1.json
  def show
  end

  # GET /user_credits/new
  def new
    @user_credit = UserCredit.new
  end

  # GET /user_credits/1/edit
  def edit
  end

  # POST /user_credits or /user_credits.json
  def create
    @user_credit = UserCredit.new(user_credit_params)

    respond_to do |format|
      if @user_credit.save
        format.html { redirect_to @user_credit, notice: "User credit was successfully created." }
        format.json { render :show, status: :created, location: @user_credit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_credits/1 or /user_credits/1.json
  def update
    respond_to do |format|
      if @user_credit.update(user_credit_params)
        format.html { redirect_to @user_credit, notice: "User credit was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user_credit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_credits/1 or /user_credits/1.json
  def destroy
    @user_credit.destroy!

    respond_to do |format|
      format.html { redirect_to user_credits_path, notice: "User credit was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_credit
      @user_credit = UserCredit.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_credit_params
      params.expect(user_credit: [ :user_id, :total_credits, :used_credits, :current_balance ])
    end
end
