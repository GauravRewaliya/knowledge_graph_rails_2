class CreateUserCredits < ActiveRecord::Migration[8.0]
  def change
    create_table :user_credits do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_credits
      t.decimal :used_credits
      t.decimal :current_balance

      t.timestamps
    end
  end
end
