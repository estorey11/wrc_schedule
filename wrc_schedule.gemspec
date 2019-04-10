
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wrc_schedule/version"

Gem::Specification.new do |spec|
  spec.name          = "wrc_schedule"
  spec.version       = WrcSchedule::VERSION
  spec.authors       = ["estorey11"]
  spec.email         = ["estorey@gmail.com"]

  spec.summary       = "CLI Ruby gem to view the current WRC schedule and results"
  spec.description   = "This Ruby Gem utilizes a CLI to display the schedule for the current World Rally Championship season. The user can then request further info about each specific event on the schedule, as well as requesting the results of the top 20 finishers of each event"
  spec.homepage      = "https://github.com/estorey11/wrc-schedule/blob/master/wrc_schedule/Gemfile"
  spec.license       = "MIT"
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
=begin
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["https://github.com/estorey11/wrc-schedule/blob/master/wrc_schedule/Gemfile"] = "TODO: Put your gem's public repo URL here."
    spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end
=end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'terminal-table'
  spec.add_development_dependency 'watir'
  spec.add_development_dependency 'webdrivers'
end
