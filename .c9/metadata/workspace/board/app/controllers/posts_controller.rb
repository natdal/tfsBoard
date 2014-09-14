{"changed":true,"filter":false,"title":"posts_controller.rb","tooltip":"/board/app/controllers/posts_controller.rb","value":"#기본 게시판 형태의 컨트롤러\nclass PostsController < ApplicationController\n  #레일스 4부터 _filter가 _action으로 변경\n  before_action :set_bulletin#모든 액션 수행전에 수행됨\n  before_action :set_post, only: [:show, :edit, :update, :destroy]#posts 컨트롤러의 액션 중에서 show, edit,update, destroy 액션이 실행되기 전에 반드시 set_post 메소드를 실행하라는 필터\n  #before_action에 지정된 메서드는 지정된 액션이 실행되기 전에만 수행됨.\n\n  # GET /posts\n  # GET /posts.json\n  def index #DB 쿼리후, 특정 모델(들)의 모든 객체를 불러와 보여 준다\n    #@posts = Post.all\n    #@posts = @bulletin.posts.all#인스턴스 변수 @posts를 생성, 이것은 해당 뷰 템플릿(app/views/posts/index.html.erb)에서 바로 사용\n    \n    if params[:bulletin_id]#태그값이 넘어왔는지 bulletin_id값이 넘어왔는지 판단하에 인스턴스 생성\n      @posts = @bulletin.posts.all\n    else\n      if params[:tag]\n        @posts = Post.tagged_with(params[:tag])#Post.tagged_with() 클래스 메소드는 acts-as-taggable-on 젬이 지원한 메소드로 임의의 태그를 넘겨 주면 해당 태그를 포함하는 post 객체들을 반환해 준다.\n      else\n        @posts = Post.all\n      end\n    end\n  end\n\n  # GET /posts/1\n  # GET /posts/1.json\n  def show #DB 쿼리후, 특정 모델의 특정 객체만을 불러와 보여 준다.\n  end\n\n  # GET /posts/new\n  def new #데이터 조작을 하지 않고 단지 뷰를 렌더링하는 기능만을 가진다\n    #@post = Post.new\n    @post = @bulletin.posts.new\n  end#새로운 데이터를 입력 받는 폼을 응답으로 보낸다.\n\n  # GET /posts/1/edit\n  def edit #데이터 조작을 하지 않고 단지 뷰를 렌더링하는 기능만을 가진다\n  end#기존 데이터를 수정하기 위한 폼을 응답으로 보낸다.\n\n  # POST /posts\n  # POST /posts.json\n  def create #특정 모델의 한 객체를 생성하여 DB 테이블로 저장한다. 액션 종료시 show 액션으로 리디렉트\n    #@post = Post.new(post_params)\n    @post = @bulletin.posts.new(post_params)\n    \n    respond_to do |format|\n      if @post.save\n        #format.html { redirect_to @post, notice: 'Post was successfully created.' }\n        format.html { redirect_to [@post.bulletin, @post], notice: 'Post was successfully created.' }#post가 bulletin의 id값을 foregin key로 소유하고 있음.\n        format.json { render :show, status: :created, location: @post }\n      else\n        format.html { render :new }\n        format.json { render json: @post.errors, status: :unprocessable_entity }\n      end\n    end\n    \n  end\n\n  # PATCH/PUT /posts/1\n  # PATCH/PUT /posts/1.json\n  def update #DB 쿼리후, 특정 모델의 속성을 변경한 후 DB 테이블로 저장한다. 액션 종료시 show 액션으로 리디렉트된다.\n    respond_to do |format|\n      if @post.update(post_params)\n        #format.html { redirect_to @post, notice: 'Post was successfully updated.' }\n        format.html { redirect_to [@post.bulletin, @post], notice: 'Post was successfully updated.' }\n        format.json { render :show, status: :ok, location: @post }\n      else\n        format.html { render :edit }\n        format.json { render json: @post.errors, status: :unprocessable_entity }\n      end\n    end\n    \n  end\n\n  # DELETE /posts/1\n  # DELETE /posts/1.json\n  def destroy #DB 쿼리후, 특정 모델의 특정 객체(들)를 삭제한다. 액선 종류시 index 액션으로 리디렉트된다.\n    @post.destroy\n    respond_to do |format|\n      #format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }\n      format.html { redirect_to bulletin_posts_url, notice: 'Post was successfully destroyed.' }#Prefix끝에 _url이나 _path를 붙여서 helper메서드로 사용,\n                                                                                                #뷰 템플릿에서 동적 URL을 사용할 수 있도록 해 주어 정적 URL을 일일이 입력할 필요가 없게 된다.\n                                                                                                #즉, 뷰 템플릿 파일에서 <%= bulletin_posts_path('공지사항') %>와 같이 사용하면\n                                                                                                #뷰 파일이 렌더링될 때 http://localhost:3000/bulletins/공지사항/posts으로 변환된다.\n      format.json { head :no_content }\n    end\n  end\n\n  private \n    \n    def set_bulletin #모든 액션 실행전에 수행됨\n      @bulletin = Bulletin.friendly.find(params[:bulletin_id]) if params[:bulletin_id]#friendly젬 추가(id값 대신에 다른 속성값을 받을거기 때문에)\n    end\n    \n    def set_post #지정 액션 실행전에만 수행됨\n      #@post = Post.find(params[:id])#파라미터로 넘겨 받은 id 값을 이용하여 특정 post를 조회한 후 @post 인스턴스 변수에 할당\n      #@post = @bulletin.posts.find(params[:id])#bulletin에 연결된 post를 찾음\n      \n      if params[:bulletin_id]#tag로 index 호출시 :tag파라미터만 넘겨오는 경우\n        @post = @bulletin.posts.find(params[:id])\n      else\n        @post = Post.find(params[:id])\n      end\n    end\n\n    def post_params#레일스 4로 업그레이드되면서 속성 보안관련 기능이 모델로부터 컨트롤러로 이동하여 Strong Parameters의 개념으로 재구성\n      #params.require(:post).permit(:title, :content)#파라미터로 넘겨 받은 속성 중에 title과 content만을 화이트리스트로 인정하겠다는 뜻이다. 따라서 다른 속성은 save 또는 udpate 되지 않게 된다.\n      params.require(:post).permit(:title, :content, :picture, :picture_cache, :tag_list)#게시판 형태에 따른 view를 보여주기 위해 화이트리스트를 추가하였다.\n    end#레일스 3에서는 mass assignment에 대한 화이트리스트를 해당 모델 클래스에서 attr_accesible 매크로로 작성. ex)attr_accessible :title, :content\nend\n","undoManager":{"mark":40,"position":100,"stack":[[{"group":"doc","deltas":[{"action":"removeText","range":{"start":{"row":13,"column":31},"end":{"row":13,"column":47}},"text":"을 넘길지 말지에 대한 조건문"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":31},"end":{"row":13,"column":32}},"text":"이"},{"action":"insertText","range":{"start":{"row":13,"column":32},"end":{"row":13,"column":33}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":33},"end":{"row":13,"column":34}},"text":"넘"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":34},"end":{"row":13,"column":35}},"text":"어"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":35},"end":{"row":13,"column":36}},"text":"왔"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":36},"end":{"row":13,"column":37}},"text":"는"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":37},"end":{"row":13,"column":38}},"text":"지"},{"action":"insertText","range":{"start":{"row":13,"column":38},"end":{"row":13,"column":39}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":39},"end":{"row":13,"column":40}},"text":"b"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":40},"end":{"row":13,"column":41}},"text":"u"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":41},"end":{"row":13,"column":42}},"text":"l"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":42},"end":{"row":13,"column":43}},"text":"l"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":43},"end":{"row":13,"column":44}},"text":"e"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":44},"end":{"row":13,"column":45}},"text":"t"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":45},"end":{"row":13,"column":46}},"text":"i"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":46},"end":{"row":13,"column":47}},"text":"n"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":47},"end":{"row":13,"column":48}},"text":"_"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":48},"end":{"row":13,"column":49}},"text":"ㅑ"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":49},"end":{"row":13,"column":50}},"text":"ㅇ"},{"action":"insertText","range":{"start":{"row":13,"column":50},"end":{"row":13,"column":51}},"text":"\\"}]}],[{"group":"doc","deltas":[{"action":"removeText","range":{"start":{"row":13,"column":50},"end":{"row":13,"column":51}},"text":"\\"}]}],[{"group":"doc","deltas":[{"action":"removeText","range":{"start":{"row":13,"column":49},"end":{"row":13,"column":50}},"text":"ㅇ"}]}],[{"group":"doc","deltas":[{"action":"removeText","range":{"start":{"row":13,"column":48},"end":{"row":13,"column":49}},"text":"ㅑ"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":48},"end":{"row":13,"column":49}},"text":"i"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":49},"end":{"row":13,"column":50}},"text":"d"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":50},"end":{"row":13,"column":51}},"text":"값"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":51},"end":{"row":13,"column":52}},"text":"이"},{"action":"insertText","range":{"start":{"row":13,"column":52},"end":{"row":13,"column":53}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":53},"end":{"row":13,"column":54}},"text":"넘"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":54},"end":{"row":13,"column":55}},"text":"어"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":55},"end":{"row":13,"column":56}},"text":"왔"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":56},"end":{"row":13,"column":57}},"text":"는"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":57},"end":{"row":13,"column":58}},"text":"지"},{"action":"insertText","range":{"start":{"row":13,"column":58},"end":{"row":13,"column":59}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":59},"end":{"row":13,"column":60}},"text":"판"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":60},"end":{"row":13,"column":61}},"text":"단"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":61},"end":{"row":13,"column":62}},"text":"하"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":62},"end":{"row":13,"column":63}},"text":"에"},{"action":"insertText","range":{"start":{"row":13,"column":63},"end":{"row":13,"column":64}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":64},"end":{"row":13,"column":65}},"text":"인"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":65},"end":{"row":13,"column":66}},"text":"스"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":66},"end":{"row":13,"column":67}},"text":"턴"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":67},"end":{"row":13,"column":68}},"text":"스"},{"action":"insertText","range":{"start":{"row":13,"column":68},"end":{"row":13,"column":69}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":69},"end":{"row":13,"column":70}},"text":"생"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":13,"column":70},"end":{"row":13,"column":71}},"text":"성"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":91,"column":62},"end":{"row":91,"column":86}},"text":" if params[:bulletin_id]"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":96,"column":70},"end":{"row":97,"column":0}},"text":"\n"},{"action":"insertText","range":{"start":{"row":97,"column":0},"end":{"row":97,"column":6}},"text":"      "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":97,"column":6},"end":{"row":98,"column":0}},"text":"\n"},{"action":"insertText","range":{"start":{"row":98,"column":0},"end":{"row":98,"column":6}},"text":"      "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":6},"end":{"row":98,"column":29}},"text":"if params[:bulletin_id]"},{"action":"insertText","range":{"start":{"row":98,"column":29},"end":{"row":99,"column":0}},"text":"\n"},{"action":"insertLines","range":{"start":{"row":99,"column":0},"end":{"row":102,"column":0}},"lines":["      @post = @bulletin.posts.find(params[:id])","    else","      @post = Post.find(params[:id])"]},{"action":"insertText","range":{"start":{"row":102,"column":0},"end":{"row":102,"column":7}},"text":"    end"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":100,"column":4},"end":{"row":100,"column":6}},"text":"  "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":99,"column":6},"end":{"row":99,"column":8}},"text":"  "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":101,"column":6},"end":{"row":101,"column":8}},"text":"  "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":102,"column":4},"end":{"row":102,"column":6}},"text":"  "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":96,"column":6},"end":{"row":96,"column":7}},"text":"#"}]}],[{"group":"doc","deltas":[{"action":"removeText","range":{"start":{"row":98,"column":0},"end":{"row":98,"column":6}},"text":"      "},{"action":"removeText","range":{"start":{"row":97,"column":6},"end":{"row":98,"column":0}},"text":"\n"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":97,"column":6},"end":{"row":98,"column":0}},"text":"\n"},{"action":"insertText","range":{"start":{"row":98,"column":0},"end":{"row":98,"column":6}},"text":"      "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":29},"end":{"row":98,"column":30}},"text":"#"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":30},"end":{"row":98,"column":31}},"text":"i"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":31},"end":{"row":98,"column":32}},"text":"n"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":32},"end":{"row":98,"column":33}},"text":"d"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":33},"end":{"row":98,"column":34}},"text":"e"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":34},"end":{"row":98,"column":35}},"text":"x"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":35},"end":{"row":98,"column":36}},"text":"x"}]}],[{"group":"doc","deltas":[{"action":"removeText","range":{"start":{"row":98,"column":35},"end":{"row":98,"column":36}},"text":"x"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":35},"end":{"row":98,"column":36}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":36},"end":{"row":98,"column":37}},"text":"호"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":37},"end":{"row":98,"column":38}},"text":"출"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":38},"end":{"row":98,"column":39}},"text":"시"},{"action":"insertText","range":{"start":{"row":98,"column":39},"end":{"row":98,"column":40}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":40},"end":{"row":98,"column":41}},"text":":"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":41},"end":{"row":98,"column":42}},"text":"t"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":42},"end":{"row":98,"column":43}},"text":"a"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":43},"end":{"row":98,"column":44}},"text":"g"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":44},"end":{"row":98,"column":45}},"text":"파"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":45},"end":{"row":98,"column":46}},"text":"라"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":46},"end":{"row":98,"column":47}},"text":"미"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":47},"end":{"row":98,"column":48}},"text":"터"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":48},"end":{"row":98,"column":49}},"text":"만"},{"action":"insertText","range":{"start":{"row":98,"column":49},"end":{"row":98,"column":50}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":50},"end":{"row":98,"column":51}},"text":"넘"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":51},"end":{"row":98,"column":52}},"text":"겨"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":52},"end":{"row":98,"column":53}},"text":"오"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":53},"end":{"row":98,"column":54}},"text":"는"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":54},"end":{"row":98,"column":55}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":55},"end":{"row":98,"column":56}},"text":"경"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":56},"end":{"row":98,"column":57}},"text":"우"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":57},"end":{"row":98,"column":58}},"text":"떄"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":58},"end":{"row":98,"column":59}},"text":"문"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":59},"end":{"row":98,"column":60}},"text":"에"}]}],[{"group":"doc","deltas":[{"action":"removeText","range":{"start":{"row":98,"column":57},"end":{"row":98,"column":60}},"text":"떄문에"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":30},"end":{"row":98,"column":31}},"text":"t"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":31},"end":{"row":98,"column":32}},"text":"a"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":32},"end":{"row":98,"column":33}},"text":"g"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":33},"end":{"row":98,"column":34}},"text":"로"},{"action":"insertText","range":{"start":{"row":98,"column":34},"end":{"row":98,"column":35}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":98,"column":35},"end":{"row":98,"column":36}},"text":"호"}]}],[{"group":"doc","deltas":[{"action":"removeText","range":{"start":{"row":98,"column":35},"end":{"row":98,"column":36}},"text":"호"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":47},"end":{"row":17,"column":48}},"text":"#"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":48},"end":{"row":17,"column":66}},"text":"Post.tagged_with()"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":66},"end":{"row":17,"column":67}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":67},"end":{"row":17,"column":68}},"text":"클"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":68},"end":{"row":17,"column":69}},"text":"래"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":69},"end":{"row":17,"column":70}},"text":"스"},{"action":"insertText","range":{"start":{"row":17,"column":70},"end":{"row":17,"column":71}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":71},"end":{"row":17,"column":72}},"text":"메"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":72},"end":{"row":17,"column":73}},"text":"소"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":73},"end":{"row":17,"column":74}},"text":"드"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":74},"end":{"row":17,"column":75}},"text":"는"}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":75},"end":{"row":17,"column":76}},"text":" "}]}],[{"group":"doc","deltas":[{"action":"insertText","range":{"start":{"row":17,"column":76},"end":{"row":17,"column":151}},"text":"acts-as-taggable-on 젬이 지원한 메소드로 임의의 태그를 넘겨 주면 해당 태그를 포함하는 post 객체들을 반환해 준다."}]}]]},"ace":{"folds":[],"scrolltop":0,"scrollleft":0,"selection":{"start":{"row":17,"column":151},"end":{"row":17,"column":151},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":0},"timestamp":1410702873964}