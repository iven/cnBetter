migration 1, :create_articles do
  up do
    create_table :articles do
      column :id, Integer, :serial => true
      column :id, Integer
      column :title, String, :length => 255
      column :content, Text
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end

  down do
    drop_table :articles
  end
end
