module ApplicationHelper
    
    def bootstrap_class_for(flash_type) #bootstrap 3 문서 참조
    case flash_type
      when "success"
        "alert-success"   # 초록색
      when "error"
        "alert-danger"    # 빨간색
      when "alert"
        "alert-warning"   # 노랑색
      when "notice"
        "alert-info"      # 파랑색
      else
        flash_type.to_s
    end
  end
  
  def icon(font)
    "<span class='glyphicon glyphicon-#{font}'></span>".html_safe
  end
  
  def tag_icons(tag_list)
  tag_list.map do | tag |
    "<a href='/posts?tag=#{CGI::escape(tag)}' class='tag'>#{tag}</a>"#CGI::escape() 메소드는 태그에서 사용할 수 있는 특수문자를 이스케이핑하기 위한 것이다.
  end.join(', ').html_safe
end
  
end
