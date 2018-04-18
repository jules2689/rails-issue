class CreateMyModels < ActiveRecord::Migration[5.2]
  def change
    create_table :my_models do |t|
      t.boolean :my_value
      t.references :parent_model

      t.timestamps
    end
  end
end
