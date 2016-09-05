def client
  Elasticsearch::Client.new log: true
end
