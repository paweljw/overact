Hanami::Model.migration do
  change do
    alter_table :actors do
      add_column :photo_data, :jsonb, null: true
    end
  end
end
