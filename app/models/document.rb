class Document
  include ActiveModel::Model
  include ActiveModel::Dirty
  include ActiveModel::AttributeAssignment
  include SearchHelper

  attr_reader :id, :title, :release_date, :vod_date, :blu_ray_date, :premium_date, :capsule, :watched, :tags

  define_attribute_methods :id, :title, :release_date, :vod_date, :blu_ray_date, :premium_date, :capsule, :watched, :tags

  def initialize(attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @release_date = attributes[:release_date]
    @vod_date = attributes[:vod_date]
    @blu_ray_date = attributes[:blu_ray_date]
    @premium_date = attributes[:premium_date]
    @capsule = attributes[:capsule]
    @watched = attributes[:watched]
    @tags = attributes[:tags]
  end

  def id=(val)
    id_will_change! unless val == @id
    @id = val
  end

  def title=(val)
    title_will_change! unless val == @title
    @title = val
  end

  def release_date=(val)
    release_date_will_change! unless val == @release_date
    @release_date = val
  end

  def vod_date=(val)
    vod_date_will_change! unless val == @vod_date
    @vod_date = val
  end

  def blu_ray_date=(val)
    blu_ray_date_will_change! unless val == @blu_ray_date
    @blu_ray_date = val
  end

  def premium_date=(val)
    premium_date_will_change! unless val == @premium_date
    @premium_date = val
  end

  def capsule=(val)
    capsule_will_change! unless val == @capsule
    @capsule = val
  end

  def watched=(val)
    _watched = %w(true 1).include?(val)
    watched_will_change! unless _watched == @watched
    @watched = _watched
  end

  def tags=(val)
    tags_will_change! unless val == @tags
    @tags = val
  end

  def persisted?
    !id.blank?
  end

  def reload!
    clear_changes_information
  end

  def rollback!
    initialize(get_document_attributes(@id))
    restore_attributes
  end

  def save
    changed_applied
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
