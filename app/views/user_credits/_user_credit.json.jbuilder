json.extract! user_credit, :id, :user_id, :total_credits, :used_credits, :current_balance, :created_at, :updated_at
json.url user_credit_url(user_credit, format: :json)
