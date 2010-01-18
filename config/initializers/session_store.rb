# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cv_session',
  :secret      => 'f1deec2ac9a874515bcb8739e42a52990246fb30f09bd40f10337e64d38aa284f83eed758af5d2a7de19487a59f680f76aa0bc94d0a853d52db2984d7f0537d7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
