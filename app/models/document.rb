class Document
  include ActiveModel::Model

  attr_accessor :id, :title, :release_date, :vod_date, :blu_ray_date, :premium_date, :capsule, :watched, :tags

  def initialize()
    @tags = []
    @watched = false
  end

  def self.build_from_hit(hit)
    Document.new.tap do |document|
      document.id = hit['_id']
      hit['_source'].tap do |source|
        document.title = source['title']
        document.release_date = source['release_date']
        document.vod_date = source['vod_date']
        document.blu_ray_date = source['blu_ray_date']
        document.premium_date = source['premium_date']
        document.capsule = source['capsule']
        document.watched = source['watched']
        document.tags = source['tags']
      end
    end
  end

  alias_method :watched?, :watched

  def to_hash
    {
        id: id,
        title: title,
        capsule: capsule,
        release_date: release_date,
        vod_date: vod_date,
        blu_ray_date: blu_ray_date,
        premium_date: premium_date,
        watched: watched,
        tags: tags
    }
  end

end
