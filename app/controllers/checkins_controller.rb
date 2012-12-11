class CheckinsController < ApplicationController
  config.force_ssl = true

  def push
    if params[:secret] == 'R3QCIQED4YOUISPQ0C4JU3GNWRNL0MDCYWHODCWGC1Z2DJKV'
      checkin = JSON.parse(params[:checkin])
      user = User.where(uid: checkin["user"]["id"])
 
      tweet = Twitter.search(checkin["venue"]["name"], :count => 1 , :geocode => "#{checkin["venue"]["location"]["lat"]},#{checkin["venue"]["location"]["lng"]},1mi", :result_type => "recent").results.first
      
      if tweet != nil
        tweet_time = ((Time.now - tweet.created_at)/60).round
        tweet_user_url = "https://mobile.twitter.com/#{tweet.from_user}"
          if tweet_time < 60 
            tweet_time_text = "#{tweet_time} minutes ago"
          elsif tweet_time >= 60 && tweet_time < 90  
            tweet_time_text = "about 1 hour ago"
          elsif (tweet_time/60) >= 48
            tweet_time_text = "about #{((tweet_time/60)/24).round} days ago"   
          else
            tweet_time_text = "about #{(tweet_time/60).round} hours ago"
          end
        tweet_text = "@#{tweet.from_user} : #{tweet.text} - #{tweet_time_text}"   
      else
        tweet_user_url = nil
        tweet_text = "Sorry! No recent tweets from your location."
      end  
      
      reply = HTTParty.post(URI.encode("https://api.foursquare.com/v2/checkins/#{checkin['id']}/reply?text=#{tweet_text}&oauth_token=#{user.first.oauth_token}&url=#{tweet_user_url}&v=20121031"))

      render :json => reply unless reply.empty?
    else
      raise  "secret does not match"
    end
  end
end
