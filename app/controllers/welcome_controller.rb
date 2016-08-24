require 'rubygems'
require 'streamio-ffmpeg'
require 'curb'


class WelcomeController < ApplicationController
  def index
   #  byebug
   #  http = Curl.get("http://stackoverflow.com/questions/15804425/curl-on-ruby-on-rails")
   #  puts http
   #
   #  http = Curl.post("http://www.google.com/", {:foo => "bar"})
   # # puts http.body_str
   #
   #  http = Curl.get("http://www.google.com/") do|http|
   #    http.headers['Cookie'] = 'foo=1;bar=2'
   #  end
    #puts http.body_str

    if params[:hash_url].present?
        hash_url = params[:hash_url]
        @url = Link.find_by_hash_url(hash_url).url
        render 'welcome/view_video', url: @url
    else
      render 'index'
    end
  end

  def upload
    if params[:data].present?
      temp_file_name = params[:data].tempfile.path
      link = Link.new
      link.hash_url = LinkService.generate_anonymous_link_hash
      link.save

      widescreen_movie = FFMPEG::Movie.new(temp_file_name)
      transcoder_options = { preserve_aspect_ratio: :width }
      widescreen_movie.transcode("movies/#{link.hash_url}.mp4", transcoder_options)

      s3 = Aws::S3::Resource.new(region:'us-west-2')
      s3_obj = s3.bucket('screencaster-purrweb').object("movies/#{link.hash_url}.mp4")
      s3_obj.upload_file("movies/#{link.hash_url}.mp4")
      link.update_attributes({url: s3_obj.public_url})


    end
    render json: {hash_url: link.hash_url}
  end
end
# <%= progress_bar(33, :color => 'blue', :rounded => true) %>
