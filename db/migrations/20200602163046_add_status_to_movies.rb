Hanami::Model.migration do
  change do
    alter_table :movies do
      add_column :status, String, null: false, default: 'checking'
    end
  end
end
