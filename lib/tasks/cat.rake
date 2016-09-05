namespace 'cat' do

  task 'count' do
    client = Elasticsearch::Client.new log: true
    puts client.cat.count index: 'movies'
  end

end
