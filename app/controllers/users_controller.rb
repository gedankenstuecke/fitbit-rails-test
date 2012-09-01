class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  
  def start_fitbit_auth
    client = Fitgem::Client.new({:consumer_key => APP_CONFIG[:fitbit_consumer_key], :consumer_secret => APP_CONFIG[:fitbit_consumer_secret]})
    request_token = client.request_token
    current_user.request_token = request_token.token
    current_user.request_secret = request_token.secret
    current_user.save
    puts "Request Token:"+ current_user.request_token.to_s + "|" + client.request_token.token.to_s
    puts "Request Secret:"+ current_user.request_secret.to_s + "|" + client.request_token.secret.to_s
    redirect_to "http://www.fitbit.com/oauth/authorize?oauth_token=#{request_token.token}"
  end

  def verify_fitbit
    if params[:oauth_token] && params[:oauth_verifier]
      @client = Fitgem::Client.new(:consumer_key => APP_CONFIG[:fitbit_consumer_key], :consumer_secret => APP_CONFIG[:fitbit_consumer_secret])
      token = params[:oauth_token]
      secret = current_user.request_secret
      verifier = params[:oauth_verifier]
      begin 
        access_token = @client.authorize(token, secret, { :oauth_verifier => verifier })
      rescue
        redirect_to root_url
      end
      current_user.access_token = access_token.token
      current_user.access_secret = access_token.secret
      current_user.verifier = verifier
      puts "TOKEN:" + access_token.token
      puts "SECRET:" + access_token.secret
      current_user.fitbit_user_id = @client.user_info["user"]["encodedId"]
      current_user.save
      redirect_to root_url
    else
      redirect_to user_profile_path
    end
  end

  def subscription_getter
    puts "PARAMETERS:"
    puts params
    read = params["updates"]
    puts read
    read_json = read.read
    notification = JSON.parse(read_json)
    puts notification[0]
    puts notification[0]["collectionType"]
  
    render :nothing => true, :status => 204
  end
end

