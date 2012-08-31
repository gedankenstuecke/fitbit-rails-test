class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :request_token
      t.string :request_secret
      t.string :access_token
      t.string :access_secret
      t.string :verifier
      t.string :fitbit_user_id
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
