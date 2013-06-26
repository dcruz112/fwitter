class RetweetsController < ApplicationController
  # before_action :set_retweet, only: [:show, :edit, :update, :destroy]

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
    
    #@retweet.save

    respond_to do |format|
      if @retweet.save
        format.html { redirect_to @retweet, notice: 'Retweet was successfully created.' }
        format.json { render action: 'show', status: :created, location: @retweet }
      else
        format.html { render action: 'new' }
        format.json { render json: @retweet.errors, status: :unprocessable_entity }
      end
    end



    redirect_to tweets_path

  end




  # PATCH/PUT /retweets/1
  # PATCH/PUT /retweets/1.json
  def update
    respond_to do |format|
      if @retweet.update(retweet_params)
        format.html { redirect_to @retweet, notice: 'Retweet was successfully updated.' }
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
    death = Retweet.where(tweet_id: @tweet.id)
    death.each do |die|
      die.destroy
    end
    respond_to do |format|
      format.html { redirect_to retweets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_retweet
    #   @retweet = Retweet.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retweet_params
      params.require(:retweet).permit(:content, :user_id, :poster_id, :tweet_id)
    end
end
