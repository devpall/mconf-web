# Require Station Model
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/models/site"

class Site


  def signature_in_html
    if signature
      return signature.gsub(/\r\n?/,'<br>')
    else
      return ""
    end
  end

end