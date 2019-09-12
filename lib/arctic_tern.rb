require 'active_support'
require 'action_view'
require 'colorize'
# require_relative 'gem_info'

module ArcticTern
  def self.call(gemfile, lockfile)
    definitions = Bundler::Definition.build(gemfile, lockfile, false)

    up_to_date = 0
    outdated = 0
    oudated_by = []

    definitions.locked_gems.specs.each do |spec|
      name = spec.name
      current_version = spec.version.to_s

      latest_spec = Gem.latest_spec_for(name)
      latest_version = latest_spec.version.to_s

      if current_version == latest_version
        up_to_date += 1
        puts "#{name} #{latest_version}".green
      else
        outdated += 1
        puts "#{name} #{current_version} -> #{latest_version}".red

        dep = Gem::Dependency.new(name, current_version)
        current_spec = Gem::SpecFetcher.fetcher.spec_for_dependency dep
        current_gemspec = current_spec.first.first.first
        current_spec_date = current_gemspec.date

        days_between = (latest_spec.date.to_date - current_spec_date.to_date).to_i
        # puts "outdated by #{days_between} days."
        oudated_by << days_between
      end

    rescue => _error
      puts "Error checking #{name}"
    end

    puts "\nUp to date: #{up_to_date}, Outdated: #{outdated}"
    total = up_to_date + outdated
    puts "#{(up_to_date/total.to_f * 100).ceil}% of dependencies up to date"

    filtered = oudated_by.filter { |x| x > 0 }

    count = filtered.count
    average = (filtered.sum / count.to_f).ceil

    puts "Out of date dependencies outdated by an average of #{average} days"
  end
end
