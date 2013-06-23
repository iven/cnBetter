migration 2, :create_comments do
  up do
    create_table :comments do
      column :id, Integer, :serial => true
      column :author, String, :length => 255
      column :title, Text
      column :region, Text
      column :content, Text
      column :support, Integer
      column :against, Integer
      column :posted_at, DateTime
    end
  end

  down do
    drop_table :comments
  end
end
