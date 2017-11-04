module ApplicationHelper
    def login_helper
       if current_user
          "<li>#{link_to 'Logout', destroy_user_session_path, method: :delete}</li>".html_safe
       else
          "<li>#{link_to 'Sign In', new_user_session_path}</li>".html_safe
       end
    end
    def check_value arg
      if arg
        "checked"
      else
        ""
      end
    end
end
