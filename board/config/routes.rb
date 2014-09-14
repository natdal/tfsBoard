Rails.application.routes.draw do
  
  #get 'board/index'
  root 'board#index' #board 컨트롤러의 index액션을 기본 root로 설정

  #resources :bulletins
  #resources :posts
  #중첩 라우팅. RESTful URI로 들어오는 값을 중첩시킴
  resources :bulletins do #bulletins/:bulletin_id/posts(.:format) 요청에 따라 심볼에 매칭되는 부분은 params[]해쉬의 키로 사용되어 해당 파라미터의 값을 불러올 수 있게 된다. 여기선 params[:bulletin_id]
    resources :posts #post 모델 생성 라우팅 선언(리소스 라우팅이라고 함) - rake routes로 사용할 수 있는 라우트 확인
  end
  
  #get 'comments/create'
  #get 'comments/destroy'
  resources :posts do
    resources :comments, only: [:create, :destroy]#필요한 라우트는 create와 destroy 두개뿐
  end

end
