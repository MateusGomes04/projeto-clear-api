class ApplicationController < ActionController::API
  respond_to :json
  private
  # Check for auth headers - if present, decode or send unauthorized response (called always to allow current_user)
  # If user has not signed in, return unauthorized response (called only when auth is needed)
  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end
  
  # set Devise's current_user using decoded JWT instead of session
  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  # check that authenticate_user has successfully returned @current_user_id (user is authenticated)
  def signed_in?
    @current_user_id.present?
  end

  def authenticate_user
        
    if request.headers['Authorization'].present?
      begin
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], '').first
        @current_user_id = jwt_payload['id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    else 
      head :unauthorized
    end
  end
end
