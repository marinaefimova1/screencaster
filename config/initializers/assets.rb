# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
# Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# This is your S3 bucket information
# config.aws_bucket = ENV.fetch('purrweb-scip')
# config.aws_access_key_id = ENV.fetch('AWS_ACCESS_KEY_ID')
# config.aws_secret_access_key = ENV.fetch('AWS_SECRET_ACCESS_KEY')




# Be sure to restart your server when you modify this file.
require 'aws-sdk'

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path


Aws.config.update({region: 'us-west-2',credentials: Aws::Credentials.new('AKIAIZX5YLILX5Q2LOZA', 'gFf47f0ls+YHvNHIjJ5J4TyhNKZQb5gaqfp+vM09')})

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )