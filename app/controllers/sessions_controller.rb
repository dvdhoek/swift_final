class SessionsController < Clearance::SessionsController
  protect_from_forgery :except => [:destroy]
  def create_from_omniauth

    auth_hash = request.env["omniauth.auth"]
  
    authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) || Authentication.create_with_omniauth(auth_hash)
    if authentication.user
      user = authentication.user 
      authentication.update_token(auth_hash)
    else
      user = User.create_with_auth_and_hash(authentication,auth_hash)
    end
    sign_in(user)
    redirect_to '/home'
  end

  #sign out
  def destroy
    session.delete(current_user.id)
  end

end