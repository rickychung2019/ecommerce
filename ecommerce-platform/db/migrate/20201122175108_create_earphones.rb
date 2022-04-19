class CreateEarphones < ActiveRecord::Migration[6.0]
  def change
    create_table :earphones do |t|
      t.string :title
      t.string :image
      t.integer :price

      t.timestamps
    end
  end
end
