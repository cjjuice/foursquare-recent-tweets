class CheckinsController < ApplicationController
  config.force_ssl = true

  def push
    if params[:secret] == 'R3QCIQED4YOUISPQ0C4JU3GNWRNL0MDCYWHODCWGC1Z2DJKV'
      checkin = JSON.parse(params[:checkin])
      user = User.where(uid: checkin["user"]["id"])
 
      tweet = Twitter.search(checkin["venue"]["name"], :count => 1 , :geocode => "#{checkin["venue"]["location"]["lat"]},#{checkin["venue"]["location"]["lng"]},1mi").results.first
      tweet_user = tweet.from_user
      tweet_text = tweet.text


      reply = "https://api.foursquare.com/v2/checkins/#{checkin['id']}/reply?text=#{tweet_user}:#{tweet_text}&oauth_token=#{user.oauth_token}"

      render :json => reply unless reply.empty?
    else
      raise  "secret does not match"
    end
  end
end
