module HerokubedWorld
  def call_heroku(http_method, api_call)
    expect(`echo $HEROKU_TOKEN`.chomp).not_to be_empty, 'Must supply HEROKU_TOKEN as environment variable.'
    `curl -s -X #{http_method} https://api.heroku.com/#{api_call} -H "Accept: application/vnd.heroku+json; version=3" -H "Authorization: Bearer $HEROKU_TOKEN"`
  end
end

World(HerokubedWorld)