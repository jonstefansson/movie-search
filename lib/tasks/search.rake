require 'elasticsearch/dsl'
include Elasticsearch::DSL

namespace 'search' do

  task 'query', [:query] do |t, args|
    response = client.search index: 'movies',
      body: {
        sort: [{release_date: {order: 'asc'}}],
        query: {
          query_string: {query: args[:query]}
        }
      }
    hits = response.fetch('hits')
    ap 'Total Hits: %d' % hits.fetch('total')
    hits.fetch('hits').each do |hit|
      ap(
        {
          id: hit.fetch('_id'),
          score: hit.fetch('_score'),
          source: hit.fetch('_source')
        }
      )
    end
  end

  task 'match_all' do
    definition = search do
      sort do
        by :release_date, order: 'asc'
      end
      query do
        match_all
      end
    end
    response = client.search index: 'movies', body: definition
    ap(response)
  end

end
