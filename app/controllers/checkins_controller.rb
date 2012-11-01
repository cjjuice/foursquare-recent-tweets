class CheckinsController < ApplicationController
  config.force_ssl = true

  def push
    if params[:secret] == 'R3QCIQED4YOUISPQ0C4JU3GNWRNL0MDCYWHODCWGC1Z2DJKV'
      checkin = JSON.parse(params[:checkin])
      user = User.where(uid: checkin["user"]["id"])
 
      tweet = Twitter.search(checkin["venue"]["name"], :count => 1 , :geocode => "#{checkin["venue"]["location"]["lat"]},#{checkin["venue"]["location"]["lng"]},1mi", :result_type => "recent").results.first
      tweet_time = ((Time.now - tweet.created_at)/60).round
      
      
      if tweet_time < 60 
        tweet_time_text = "#{tweet_time} minutes ago"
      elsif tweet_time >= 60 && tweet_time < 90  
        tweet_time_text = "about 1 hour ago"
      else
        tweet_time_text = "about #{(tweet_time/60).round} hours ago"
      end
          
      if tweet != nil
        tweet_text = "@#{tweet.from_user} : #{tweet.text} - #{tweet_time_text}" 
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
