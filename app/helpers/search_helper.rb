module SearchHelper

  INDEX_NAME = 'movies'
  INDEX_TYPE = 'movie'

  def get_document_attributes(id)
    response = client.get index: INDEX_NAME, id: params[:id]
    hit_to_hash(response)
  end

  def hit_to_hash(hit)
    {
        id:           hit['_id'],
        title:        hit['_source']['title'],
        release_date: hit['_source']['release_date'],
        vod_date:     hit['_source']['vod_date'],
        blu_ray_date: hit['_source']['blu_ray_date'],
        premium_date: hit['_source']['premium_date'],
        capsule:      hit['_source']['capsule'],
        watched:      hit['_source']['watched'],
        tags:         hit['_source']['tags']
    }
  end

  def update_document(document)
    attributes = Hash[document.changes.each.collect{|k,v| [k, v[1]]}]
    client.update index: INDEX_NAME, type: INDEX_TYPE, id: document.id, body: {
        doc: attributes
    }
  end

  def client
    @client ||= Elasticsearch::Client.new log: true
  end

end
