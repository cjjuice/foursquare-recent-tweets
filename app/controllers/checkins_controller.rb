class CheckinsController < ApplicationController
  config.force_ssl = true

  def push
    if params[:secret] == 'R3QCIQED4YOUISPQ0C4JU3GNWRNL0MDCYWHODCWGC1Z2DJKV'
      checkin = JSON.parse(params[:checkin])
      user = User.where uid: checkin["user"]["id"]
      recent_tweet = JSON.parse("http://search.twitter.com/search.json?q=#{checkin["venue"]["name"]}&geocode=#{checkin["venue"]["location"]["lat"]},#{checkin["venue"]["location"]["lng"]},1mi&rpp=1")    
    
      reply = "https://api.foursquare.com/v2/checkins/#{checkin["id"]}/reply?text=#{recent_tweet["results"].first["from_user_name"]} : #{recent_tweet["results"].first["text"]}&oauth_token=#{user.oauth_token}"

      render :json => reply  unless reply.empty?
    else
      raise  "secret does not match"
    end
  end
end
