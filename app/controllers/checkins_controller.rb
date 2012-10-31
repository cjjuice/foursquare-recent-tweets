class CheckinsController < ApplicationController
  config.force_ssl = true

  def push
    if params[:secret] == 'R3QCIQED4YOUISPQ0C4JU3GNWRNL0MDCYWHODCWGC1Z2DJKV'
      checkin = JSON.parse(params[:checkin])
      user = User.where uid: checkin["user"]["id"]
      #recent_tweet = JSON.parse("http://search.twitter.com/search.json?q=#{checkin["venue"]["name"]}&geocode=#{checkin["venue"]["location"]["lat"]},#{checkin["venue"]["location"]["lng"]},1mi&rpp=1")   
 
      Twitter.search(checkin["venue"]["name"], :count => 1 , :geocode => "#{checkin["venue"]["location"]["lat"]},#{checkin["venue"]["location"]["lng"]},1mi").results.map do |status|
        recent_tweet = "#{status.from_user}:#{status.text}"
      end


      reply = "https://api.foursquare.com/v2/checkins/#{checkin["id"]}/reply?text=#{recent_tweet}&oauth_token=#{user.oauth_token}"

      render :json => reply  unless reply.empty?
    else
      raise  "secret does not match"
    end
  end
end
