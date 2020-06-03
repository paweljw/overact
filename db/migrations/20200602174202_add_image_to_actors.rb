Hanami::Model.migration do
  change do
    alter_table :actors do
      add_column :image_url, String, null: true
    end
  end
end
