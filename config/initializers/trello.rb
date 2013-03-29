Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_CONSUMER_KEY']
  config.member_token = ENV['TRELLO_OAUTH_TOKEN']
end

Trello.instance_eval do
  def pipeline_board_id
    "4e722f28fbeaad21d6017682"
  end
end