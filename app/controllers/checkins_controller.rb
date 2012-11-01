class CheckinsController < ApplicationController
  config.force_ssl = true

  def push
    if params[:secret] == 'R3QCIQED4YOUISPQ0C4JU3GNWRNL0MDCYWHODCWGC1Z2DJKV'
      checkin = JSON.parse(params[:checkin])
      user = User.where(uid: checkin["user"]["id"])
 
      tweet = Twitter.search(checkin["venue"]["name"], :count => 1 , :geocode => "#{checkin["venue"]["location"]["lat"]},#{checkin["venue"]["location"]["lng"]},1mi").results.first
      
      if tweet != nil
        tweet_text = "#{tweet.from_user} : #{tweet.text}" 
      else
        tweet_text = "Sorry! No recent tweets from your location."
      end  

      reply = HTTParty.post(URI.encode("https://api.foursquare.com/v2/checkins/#{checkin['id']}/reply?text=#{tweet_text}&oauth_token=#{user.first.oauth_token}&v=20121031"))

      render :json => reply unless reply.empty?
    else
      raise  "secret does not match"
    end
  end
end
