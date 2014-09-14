#Bulletin 모델과 Post모델의 관계선언
#Post 모델에 Bulletin_id값을 Foregin key로 선언
#Bulletin <= Posts
class AddBulletinIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :bulletin_id, :integer
    add_index :posts, :bulletin_id
  end
end
