class UserSession < Authlogic::Session::Base
  
  # Some Rails 3 bug authlogic hasn't figured out yet :-( for invalid UserSession saves
  # http://github.com/binarylogic/authlogic/issues/issue/101
  def to_key
    id ? id : nil
  end

end