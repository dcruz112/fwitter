class RetweetsController < ApplicationController
  before_action :set_retweet, only: [:destroy]

  # GET /retweets
  # GET /retweets.json
  def index
    @retweets = Retweet.all
  end

  # GET /retweets/1
  # GET /retweets/1.json
  def show
    @tweet = Tweet.find(params[:id])
    @retweet = Retweet.new(content: @tweet.content, user_id: @tweet.user_id,  poster_id: current_user.id, tweet_id: @tweet.id )
    @retweet.save
    redirect_to root_path
    #render @retweet
  end

  # GET /retweets/new
  def new
    @retweet = Retweet.new
  end

  # GET /retweets/1/edit
  def edit
  end

  # POST /retweets
  # POST /retweets.json
  def create
    @tweet = Tweet.find(params[:id])
    @retweet = Retweet.new(content: @tweet.content, user_id: @tweet.user_id,  poster_id: current_user.id, tweet_id: @tweet.id )
    respond_to do |format|
      if @retweet.save
        format.html { redirect_to root_path, notice: 'Retweet was successfully created.' }
        format.json { render action: 'show', status: :created, location: @retweet }
      else
        format.html { render action: 'new' }
        format.json { render json: @retweet.errors, status: :unprocessable_entity }
      end
    end

    @tweet.user.notifications.build(creator_id: self.id, content: @tweet.content, image_url: User.find(@tweet.poster_id).image_url.to_s, message: "#{User.find(@tweet.poster_id).full_name} retweeted your tweet!")
  end

  # PATCH/PUT /retweets/1
  # PATCH/PUT /retweets/1.json
  def update
    respond_to do |format|
      if @retweet.update(retweet_params)
        format.html {redirect_to retweets_path, notice: 'Retweet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @retweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /retweets/1
  # DELETE /retweets/1.json
  def destroy
    @retweet.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
    def set_retweet
      @retweet = Retweet.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
  def retweet_params
    params.require(:retweet).permit(:content, :user_id, :poster_id, :tweet_id)
  end
end
