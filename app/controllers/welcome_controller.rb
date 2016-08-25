require 'rubygems'
require 'streamio-ffmpeg'
require 'curb'
require 'json'

class WelcomeController < ApplicationController
  def index
    if params[:code].present?
      # byebug
      code = params[:code]
      http = Curl.post("https://slack.com/api/oauth.access", {client_id: '9390867412.72436541940', client_secret: 'bf4915d1940e75a8843b91fac64e7743', code: code})
      puts http.body_str
      parsed_json = JSON.parse(http.body_str)
      # save token, team_id, team_name
      integrate = Integration.new(access_token: parsed_json['access_token'], user_id: parsed_json['user_id'],
                                  team_id: parsed_json['team_id'], team_name: parsed_json['team_name'],
                                  channel: parsed_json['incoming_webhook']['channel'],
                                  channel_id: parsed_json['incoming_webhook']['channel_id'],
                                  url: parsed_json['incoming_webhook']['url'],
                                  cofiguration_url: parsed_json['incoming_webhook']['configuration_url'])
      integrate.save
      #integrate.access_token = http.body_str()
    elsif params[:hash_url].present?
      hash_url = params[:hash_url]
      @url = Link.find_by_hash_url(hash_url).url
      render 'welcome/view_video', url: @url
    else
      render 'welcome/start_page'
    end
  end

  def upload
    if params[:data].present?
      temp_file_name = params[:data].tempfile.path
      link = Link.new
      link.hash_url = LinkService.generate_anonymous_link_hash
      link.save

      widescreen_movie = FFMPEG::Movie.new(temp_file_name)
      transcoder_options = {preserve_aspect_ratio: :width}
      widescreen_movie.transcode("movies/#{link.hash_url}.mp4", transcoder_options)

      s3 = Aws::S3::Resource.new(region: 'us-west-2')
      s3_obj = s3.bucket('screencaster-purrweb').object("movies/#{link.hash_url}.mp4")
      #s3_obj.upload_file("movies/#{link.hash_url}.mp4")
      # link.update_attributes({url: s3_obj.public_url})

    end
    render json: {hash_url: link.hash_url}
  end

  def start

  end
end
# <%= progress_bar(33, :color => 'blue', :rounded => true) %>
