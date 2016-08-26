require 'rubygems'
require 'streamio-ffmpeg'
require 'curb'
require 'json'
class AuthenticationController < ApplicationController
  def new
    byebug
    http = Curl.get("https://slack.com/oauth/authorize",{ client_id: '9390867412.72436541940', teams: 'read', users:'read'})
    puts http.body_str
    #parsed_json = JSON.parse(http.body_str)
    # if Integration.where("access_token=?", parsed_json['access_token']).first
    # redirect_to '/authentication/show'
    # end
  end

  def index
    if params[:code].present?
      # byebug
      code = params[:code]
      http = Curl.get("https://slack.com/api/oauth.access", {client_id: '9390867412.72436541940', client_secret: 'bf4915d1940e75a8843b91fac64e7743', code: code})
      parsed_json = JSON.parse(http.body_str)
      integrate = Integration.new(access_token: parsed_json['access_token'], user_id: parsed_json['user_id'],
                                  team_id: parsed_json['team_id'], team_name: parsed_json['team_name'],
                                  channel: parsed_json['incoming_webhook']['channel'],
                                  channel_id: parsed_json['incoming_webhook']['channel_id'],
                                  url: parsed_json['incoming_webhook']['url'],
                                  cofiguration_url: parsed_json['incoming_webhook']['configuration_url'])
      integrate.save
    end
   redirect_to '/authentication/show'
  end

  def show
  end
end
