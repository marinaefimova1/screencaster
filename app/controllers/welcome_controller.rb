require 'rubygems'
require 'streamio-ffmpeg'

class WelcomeController < ApplicationController
  def index
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
