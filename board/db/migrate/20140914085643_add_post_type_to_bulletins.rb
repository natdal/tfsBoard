#게시판의 용도를 나누기 위한 모델
class AddPostTypeToBulletins < ActiveRecord::Migration
  def change
    #기본적으로 bulletin, blog, gallery값을 가질것이다.
    #add_column :bulletins, :post_type, :string
    add_column :bulletins, :post_type, :string, default: 'bulletin'#디폴트값으로 bulletin 지정
  end
end
