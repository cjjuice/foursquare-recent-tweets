class PagesController < ApplicationController

 def index
 end

 def success
   redirect_to root_url , notice: 'Welcome aboard! Recent Tweet was successfully connected!'
 end

end
