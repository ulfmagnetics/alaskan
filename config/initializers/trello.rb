Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_CONSUMER_KEY']
  config.member_token = ENV['TRELLO_OAUTH_TOKEN']
end

PIPELINE_BOARD = Trello::Board.find("4e722f28fbeaad21d6017682")