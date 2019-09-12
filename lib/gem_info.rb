class GemInfo
  include ActionView::Helpers::DateHelper

  class NullGemInfo < GemInfo
    def initialize; end

    def age
      "-"
    end

    def time_to_latest_version
      "-"
    end

    def created_at
      Time.now
    end

    def up_to_date?
      false
    end

    def version
      "NOT FOUND"
    end

    def state(_)
      :null
    end
  end

  def self.all
    Gem::Specification.each.map do |gem_specification|
      new(gem_specification)
    end
  end

  attr_reader :gem_specification, :version, :name
  def initialize(gem_specification)
    @gem_specification = gem_specification
    @version = gem_specification.version
    @name = gem_specification.name
  end

  def age
    "#{time_ago_in_words(created_at)} ago"
  end

  def sourced_from_git?
    !!gem_specification.git_version
  end

  def time_to_latest_version
    distance_of_time_in_words(created_at, latest_version.created_at)
  end

  def created_at
    @created_at ||= gem_specification.date
  end

  def up_to_date?
    version == latest_version.version
  end

  def latest_version
    @latest_version ||= begin
      latest_gem_specification = Gem.latest_spec_for(name)
      if latest_gem_specification
        GemInfo.new(latest_gem_specification)
      else
        NullGemInfo.new
      end
    end
  end
end
