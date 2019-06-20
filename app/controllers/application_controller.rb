class ApplicationController < ActionController::API
  # before_action :valid_signature?
  #
  # private
  # def valid_signature?
  #   @oauth = Koala::Facebook::OAuth.new(ENV['facebook_ap_id'], ENV['facebook_api_secret']
  #   begin
  #     @oauth.parse_signed_request(params[:signature])
  #   rescue Koala::Facebook::OAuthSignatureError
  #     render json: {"error": "invalid signature"}
  #   rescue JSON::ParserError
  #     render json: {"error": "invalid json in signature"}, status: :forbidden
  #   rescue NoMethodError
  #     render json: {"error": "Please provide an authentication signature with this request"}, status: :forbidden
  #   end
  # end

end
