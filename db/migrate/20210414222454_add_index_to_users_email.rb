class AddIndexToUsersEmail < ActiveRecord::Migration[6.1]
  #データベースにインデックスを追加することで検索効率が向上する。また、データベースレベルでの一意性を保証するためにも使われる

  def change
    add_index :users, :email, unique: true
  end
end
