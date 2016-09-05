namespace 'index' do
  
  desc 'Creates the movies index with a mapping for the movie type'
  task 'create' do
    client.indices.create index: 'movies',
      body: {
        settings: {
          number_of_shards: 1
        },
        mappings: {
          'movie' => {
            properties: {
              'title' => {type: 'string'},
              'release_date' => {type: 'date', index: 'not_analyzed', include_in_all: false},
              'blu_ray_date' => {type: 'date', index: 'not_analyzed', include_in_all: false},
              'vod_date' => {type: 'date', index: 'not_analyzed', include_in_all: false},
              'premium_date' => {type: 'date', index: 'not_analyzed', include_in_all: false},
              'capsule' => {type: 'string'},
              'tags' => {type: 'string', index: 'not_analyzed'},
              'watched' => {type: 'boolean', index: 'not_analyzed'}
            }
          }
        }
      }
  end
  
  desc 'Deletes the movies index'
  task 'delete' do
    client = Elasticsearch::Client.new log: true
    client.indices.delete index: 'movies'
  end
  
  desc 'Loads one or more movie documents from YAML read from STDIN'
  task 'ingest' do
    movies = YAML.load(STDIN)
    movies.each do |movie|
      client.index index: 'movies', type: 'movie', body: movie
    end
    client.indices.refresh index: 'movies'
  end
  
  desc 'Refreshes the movies index'
  task 'refresh' do
    client.indices.refresh index: 'movies'
  end

  task 'get_mapping' do
    ap client.indices.get_mapping index: 'movies'
  end
  
  task 'get_document', [:id] do |t, args|
    ap client.get index: 'movies', id: args[:id]
  end

  desc 'update mapping'
  task 'put_mapping' do
    client.indices.put_mapping index: 'movies', type: 'movie', body: {
      'movie' => {
        'properties' => {
            'watched' => {type: 'boolean', index: 'not_analyzed'}
        }
      }
    }
  end


  task 'update_document' do
    id = 'AVaLvl51fjaj2SZIF3sb'
    client.update index: 'movies', type: 'movie', id: id, body: {
        doc: {blu_ray_date: '2016-08-30', vod_date: '2016-08-30'}
    }
  end

end
