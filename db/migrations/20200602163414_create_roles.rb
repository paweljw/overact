Hanami::Model.migration do
  change do
    create_table :roles do
      primary_key :id

      foreign_key :actor_id, :actors, on_delete: :cascade, null: false
      foreign_key :movie_id, :movies, on_delete: :cascade, null: false

      column :character_name, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
